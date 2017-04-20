From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/4] scsi: pmcraid: use __iomem pointers for ioctl
 argument
Date: Thu, 20 Apr 2017 20:24:46 +0100
Message-ID: <20170420192446.GS29622@ZenIV.linux.org.uk>
References: <20170420175549.3435196-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170420175549.3435196-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Berg <johannes.berg@intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 20, 2017 at 07:54:45PM +0200, Arnd Bergmann wrote:
> kernelci.org reports a new compile warning for old code in the pmcraid
> driver:
> 
> arch/mips/include/asm/uaccess.h:138:21: warning: passing argument 1 of '__access_ok' makes pointer from integer without a cast [-Wint-conversion]
> 
> The warning got introduced by a cleanup to the access_ok() helper
> that requires the argument to be a pointer, where the old version
> silently accepts 'unsigned long' arguments as it still does on most
> other architectures.
> 
> The new behavior in MIPS however seems absolutely sensible, and so far I
> could only find one other file with the same issue, so the best solution
> seems to be to clean up the pmcraid driver.
> 
> This makes the driver consistently use 'void __iomem *' pointers for
> passing around the address of the user space ioctl arguments, which gets
> rid of the kernelci warning as well as several sparse warnings.

Is there any point in keeping that access_ok() in the first place, rather
than just switching to copy_from_user()/copy_to_user() in there?  AFAICS,
it's only for the sake of the loop in pmcraid_copy_sglist():
        for (i = 0; i < (len / bsize_elem); i++, buffer += bsize_elem) {
                struct page *page = sg_page(&scatterlist[i]);

                kaddr = kmap(page);
                if (direction == DMA_TO_DEVICE)
                        rc = __copy_from_user(kaddr,
                                              (void *)buffer,
                                              bsize_elem);
                else   
                        rc = __copy_to_user((void *)buffer, kaddr, bsize_elem);

                kunmap(page);

                if (rc) {
                        pmcraid_err("failed to copy user data into sg list\n");
                        return -EFAULT;
                }

                scatterlist[i].length = bsize_elem;
        }   
and seeing that each of those calls copies is at least a full page...  If
there is an architecture where a single access_ok() costs a noticable fraction
of the time it takes to copy a full page, we have a much worse problem than
overhead in obscure ioctl...
