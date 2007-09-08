From: Peter Rasmussen <plr@udgaard.com>
Subject: Re: usb-storage and Motorola Z6
Date: Sat, 08 Sep 2007 18:08:27 +0200
Message-ID: <46E2C8FB.4090003@udgaard.com>
References: <Pine.LNX.4.44L0.0709071549060.7123-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0709071549060.7123-100000@netrider.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB users list <linux-usb-users@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Fri, 7 Sep 2007, Peter Rasmussen wrote:
>
>   
>> I'm sorry if this is a little late, but I had once had access to a Z6 
>> and believe I had it successfully connected to my Linux host, and was 
>> therefore puzzled by this message exchange.
>>
>> I have now borrowed the device again for the weekend to check it out a 
>> little more.
>>
>> Using Alan's patch below, otherwise my kernel is a standard 2.6.23-rc5 
>> (CONFIG_USB_STORAGE_DEBUG=y ) I got the following result after reboot 
>> and connecting the Z6.:
>>     
> ...
>
> In fact there was another patch from earlier in the email thread, which 
> was needed to work around the PQ = 1 problem.  Since you didn't apply 
> that patch, the SCSI disk driver wasn't bound to your Z6.
>
>   
Now I applied that patch, too, and it did make a difference, in drivers/scsi/scsi_sysfs.c I have:

static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
{
        struct scsi_device *sdp = to_scsi_device(dev);
        if (sdp->no_uld_attach)
                return 0;
        return 1;
//      return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
}

Before posting a lot of USB debug output, I'll explain a shorter version :-)

1.After reboot I connected the Z6 (incl. a micro-SD card) and got what looked good, if not the usual output from dmesg:

<snip>
scsi 0:0:0:0: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
<snip>
sd 0:0:0:0: [sda] Attached SCSI removable disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
<snip>
scsi 0:0:0:1: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
<snip>
sd 0:0:0:1: [sdb] Attached SCSI removable disk
sd 0:0:0:1: Attached scsi generic sg1 type 0
<snip>

2.I could then mount the SCSI devices like this:

# mount /dev/sda /mnt/usb
# mount /dev/sdb /mnt/usb2

When I normally with a USB mass storage device do, eg.:

# mount /dev/sda1 /mnt/usb

3.I couldn't however, always mount the mentioned devices as I would sometimes get a 'mount: No medium found' error, and a message on the mobile will sometimes show "USB connected" and sometimes "USB disconnected" even though it didn't seem to correlate to successful connection between my PC and the Z6.

4.So, something seems to be inconsistent. I have tried it with a few different cables and I can't detect a difference.

5.Should I post a full log of eg. connecting the Z6, mounting it and the SD card, accessing it and then unmounting? 
  A full log may then include failed attempts, which will perhaps give some hints at what is wrong?
  Or do you already have a pretty good idea as to what is wrong, and find that such an exercise is not really useful?

>> What I can't understand, however, is that as this mobile phone 
>> supposedly runs Linux. I can't see how Motorola could break it so badly 
>> that the USB connection now doesn't work with a PC running Linux?
>>     
>
> :-)  There's no necessary relation between the OS running on a device
> like your phone and its interoperability with computers running the
> same OS.
>
>   
Well, I would have expected that they have similar methods to connect, even though different Linux kernel version of course may have introduced some differences. My A780 has a 2.4.20 kernel and I wouldn't be surprised if other Motorola mobiles also use the 2.4.* series of Linux kernels.

>> And you say that this seems to be a more widespread problem with 
>> Motorola devices? Do you remember which ones, and do they run Linux as well?
>>     
>
> There were two problems.  First was the PQ = 1 problem; I have never
> seen it before now (so only on the Z6).  The other problem was the
> capacity, or last sector number; we know that the RAZR V3i and V3x both
> suffer from it as well.  (I have no idea whether they run Linux.)  
> Possibly other devices do too, and we just don't know about them.
>
>   
I know that those two don't run Linux, but can they connect to a Linux host, or do they also have problems?

>> The following is from connecting a Z3 that supposedly isn't based on 
>> Linux, but works all right (and this may have been the one I thought was 
>> the Z6 that I claimed worked):
>>     
> ...
>
> It looks normal.
>
>   
>> I hope perhaps it can provide some comparison info now with a device 
>> that works and one that doesn't.
>>
>> If Motorola actualy has made changes to the Linux kernel they use with 
>> the Z6, I suppose we should be able to get the actual code. Should I 
>> investigate that?
>>     
>
> Sure, go ahead and try.  Maybe you can convince them to fix their bugs!  
> Although that won't help all the units that have already been 
> manufactured...
>
>   
Well, if they could provide an update, then people that have one and want to use it with Linux should be able to get some relief.

> Alan Stern
>
>   
Peter



-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
