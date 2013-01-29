From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] [SCSI] advansys: change buildtime warning into runtime
 error
Date: Tue, 29 Jan 2013 11:20:42 +0100
Message-ID: <1359454842.1345.40.camel@x61.thuisdomein>
References: <1352113082.1434.31.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352113082.1434.31.camel@x61.thuisdomein>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-11-05 at 11:58 +0100, Paul Bolle wrote:
> Building advansys.o triggers this warning:
>     drivers/scsi/advansys.c:71:2: warning: #warning this driver is still not properly converted to the DMA API [-Wcpp]
> 
> This warning can be traced back to a patch called "advansys: add warning
> and convert #includes" which was included in v2.6.10. That patch also
> marked the driver as BROKEN.
> 
> Commit 4661e3eace2c7b8433476b5bf0ee437ab3c7dfd4 ("[SCSI] advansys
> driver: limp along on x86") enabled this driver for x86-32. And commit
> 9d511a4b29de6764931343d03e493f2e04df0271 ("[SCSI] advansys: Changes to
> work on parisc") enabled this driver for all architectures. But the
> commit explanation stated:
>     I haven't removed the #warning yet because virt_to_bus/bus_to_virt are
>     only eliminated for narrow boards.  Wide boards need more work.
> 
> Five years have passed and, apparently, those wide boards still need
> more work. So let's change the buildtime warning into a runtime error,
> only printed for those wide boards. Perhaps that might push the people
> using those wide boards to convert this driver. And for all others
> there's now one less buildtime warning to ignore.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Compile tested only. I don't have any AdvanSys SCSI boards (neither
> narrow nor wide).

The date of this message suggests I submitted this patch for a warning
seen while building v3.7-rc4. An identical warning can be seen while
building v3.8-rc5. What's the status of my patch? Did anyone find some
time to have a look at it?


Paul Bolle
