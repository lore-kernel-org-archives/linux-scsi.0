From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: [PATCH 5/6] ibmvscsi: Remove unsupported host config MAD and
 sysfs interface
Date: Thu, 4 Feb 2016 09:48:23 -0800
Message-ID: <56B38EE7.6060102@gmail.com>
References: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1454542114-1797-6-git-send-email-tyreld@linux.vnet.ibm.com>
 <20160204080317.GT27969@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160204080317.GT27969@c203.arch.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@odin.com, linux-kernel@vger.kernel.org, hare@suse.de, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On 02/04/2016 12:03 AM, Johannes Thumshirn wrote:
> On Wed, Feb 03, 2016 at 05:28:33PM -0600, Tyrel Datwyler wrote:
>> A VIOSRP_HOST_CONFIG_TYPE management datagram (MAD) has existed in
>> the code for some time. From what information I've gathered from
>> Brian King this was likely implemented on the host side in a SLES 9
>> based VIOS, which is no longer supported anywhere. Further, it is
>> not defined in PAPR or supported by any AIX based VIOS.
>>
>> Treating as bit rot and removing the sysfs interface and associated
>> host config code accordingly.
> 
> Doesn't removing a sysfs interface potentially break userspace code?
> 

In the general case yes, but I feel in this case no. First, Reading from
this config attribute of a vscsi host adapter always returns nothing.
Second, any userspace code using this attribute better be checking for
the existence of config. Just a quick look for
/sys/class/scsi_host/host*/config under other host adapters on my system
I find that attribute doesn't exist for any of them.

If there is truly enough concern that somebody may actually be accessing
this useless attribute from userspace then we can still strip out the
unsupported code, but leave the attribute and return nothing directly
from the show function.

-Tyrel
