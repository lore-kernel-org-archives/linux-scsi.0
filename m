From: Myron Stowe <myron.stowe@gmail.com>
Subject: Re: [PATCH 2/3] PCI: Handle device quirks when accessing sysfs
 resource<N> entries
Date: Fri, 22 Mar 2013 09:39:44 -0600
Message-ID: <CAL-B5D2zJYPNYcCD3StXjnmQit5k05_Zp=cjeeqRLQkzb2g4UQ@mail.gmail.com>
References: <20130321043449.7229.81056.stgit@amt.stowe>
	<20130321043502.7229.43877.stgit@amt.stowe>
	<514BAB13.3000101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <514BAB13.3000101@gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, bhelgaas@google.com, linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com, greg@kroah.com, alex.williamson@redhat.com, kay@vrfy.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 21, 2013 at 6:51 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 03/20/2013 10:35 PM, Myron Stowe wrote:
>>
>> Sysfs includes entries to memory regions that back a PCI device's BARs.
>> The pci-sysfs entries backing I/O Port BARs can be accessed by userspace,
>> providing direct access to the device's registers.  File permissions
>> prevent random users from accessing the device's registers through these
>> files, but don't stop a privileged app that chooses to ignore the purpose
>> of these files from doing so.
>>
>> There are devices with abnormally strict restrictions with respect to
>> accessing their registers; aspects that are typically handled by the
>> device's driver.  When these access restrictions are not followed - as
>> when a userspace app such as "udevadm info --attribute-walk
>> --path=/sys/..." parses though reading all the device's sysfs entries - it
>> can cause such devices to fail.
>>
>> This patch introduces a quirking mechanism that can be used to detect
>> accesses that do no meet the device's restrictions, letting a device
>> specific method intervene and decide how to progress.
>>
>> Reported-by: Xiangliang Yu <yuxiangl@marvell.com>
>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>
>
> I honestly don't think there's much point in even attempting this strategy.
> This list of devices in the quirk can't possibly be complete. It would
> likely be easier to enumerate a white-list of devices that can deal with
> their IO ports being read willy-nilly than a blacklist of those that don't,
> as there's likely countless devices that fall into this category. Even if
> they don't choke as badly as these ones do, it's quite likely that bad
> behavior will result.

For the device in question, it seems abnormally restrictive in its
access limitations to BAR1 and BAR3.  The device reserves 4 Bytes of
I/O Port space for these BARs, which is likely based on PCI's DWord
based protocol, but "chokes (we still have not received any specifics
on this yet)" on any access other than a single Byte access at offset
0x2 (x86 supports 1, 2, and 4 Byte I/O Port accesses).  This seems to
imply that the device did not back the other three reserved Bytes it
claims in any way, which again, seems peculiar to this particular
device as other similar devices tend to back the reserved bytes they
claim and return 0's when accessed.

So in the case where two entities such as the devices driver and an
app like 'udevadm' are *not* simultaneously accessing it, so in effect
the device is idle with no device driver attached and a user app like
'udevadm' accesses it: do you still contend that there are countless
devices that will not deal with their IO ports being read willy-nilly?

The reason I ask is related to what I stated in the cover [PATCH 0/3]
- "If on the other hand, consensus is that we need userspace device
register access capabilities - say for UIO drivers or such - then,
depending on the tact taken, we'll need this solution, or something
like it, as part of that overall strategy."  So, if it isn't too
uncommon for devices to choke with normal I/O Port accesses then I
believe that this solution would be part of a larger strategy to
support userspace direct access to devices and also works as a
compromise for the immediate issue today.


You make some good suggestions below on possible tactics related to
allowing userspace access to device registers but I question whether
or not we really want, or need, to.  Are we, by de-facto, just
assuming we need to?  Is there consensus that Linux needs to support
such functionality?  Yes, we are already there (to some extent) with
commit 8633328 but I think we are seeing the implications of such a
direction and we also know that the tact that this commit took should
be going away when VFIO matures.

Thanks for participating in this conversation - you helped in
understanding the real root cause in the originating thread and have
brought up some good points to consider,
 Myron

>
> I think there's a few things that need to be done:
>
> -Fix the bug in udevadm that caused it to trawl through these files
> willy-nilly,
>
> -Fix the kernel so that access through these files complies with the
> kernel's mechanisms for claiming IO/memory regions to prevent access
> conflicts (i.e. opening these files should claim the resource region they
> refer to, and should fail with EBUSY or something if another process or a
> kernel driver is using it).
>
> -Reconsider whether supporting read/write on the resource files for IO port
> regions like these makes any sense. Obviously mmap isn't very practical for
> IO port access on x86 but you could even do something like an ioctl for this
> purpose. Not very many pieces of software would need to access these files
> so it's likely OK if the API is a bit ugly. That would prevent something
> like grepping through sysfs from generating port accesses to random devices.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
