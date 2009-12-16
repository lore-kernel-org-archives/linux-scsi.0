From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] Forcing SCSI capacity for broken SD Card readers
Date: Wed, 16 Dec 2009 10:38:30 -0800
Message-ID: <da824cf30912161038r690e0032lb047c4a667f06c50@mail.gmail.com>
References: <2f83750a0910141408m44082639m13cb0bfdb5cbd5cb@mail.gmail.com>
	 <2f83750a0910141413s58df3658k5ed170541e637f1e@mail.gmail.com>
	 <da824cf30910141629m1c30521ftd6ee2ed9970a0edb@mail.gmail.com>
	 <2f83750a0912160851u4279d39v6165a82f78d17b5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:43323 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935193AbZLPSij convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2009 13:38:39 -0500
In-Reply-To: <2f83750a0912160851u4279d39v6165a82f78d17b5c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Clemens Fruhwirth <clemens@endorphin.org>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

+linux-usb

On Wed, Dec 16, 2009 at 8:51 AM, Clemens Fruhwirth
<clemens@endorphin.org> wrote:
> On Thu, Oct 15, 2009 at 1:29 AM, Grant Grundler <grundler@google.com>=
 wrote:
>> On Wed, Oct 14, 2009 at 2:13 PM, Clemens Fruhwirth
>> <clemens@endorphin.org> wrote:
>>> Short: Attached is an incomplete patch that allows user space to fo=
rce
>>> the capacity of an scsi device to a specific value. Any not over
>>> my-dead-body objections with that?
>>
>> No major objection - just the usual nits:
>> Why not make /sys/block/sdX/size writeable?
>> =C2=A0 =C2=A0(instead of adding an ioctl())
>
> Oh, I like that. Sorry it took me so long to reply. It turned out tha=
t
> this is a much better idea. The value that is printed when reading th=
e
> size attribute is to the value that I set in my patch indirectly
> through set_capacity. So, making size writable replaces that totally.
>
> Patch attached.

The code looks fine to me. From a process point of view, you just need
to repost the patch according Documentation/SubmittingPatches .
James will take attachments if you can't inline, but definitely want
a concise commit log entry and Signed-off-by: line.

Please also add "Reviewed-by: Grant Grundler <grundler@google.com>".

However, I'm suspect the is problem is really with how the block size i=
s
being reported and that bit of this puzzle isn't entirely explained yet=
=2E


>> After reading the wiki page[1], my impression is that the block size
>> gets reported wrong and thus the total capacity is miscalculated for
>> 1GB-4GB SD cards with 1024 or 2048 byte blocks. Two questions around=
 this:
>> a) Does the host need to know the correct block size for correct ope=
ration?
>
> From experiments it does not look like that's the case. This is
> surprising though, as one would suspect the card not to =C2=A0functio=
n
> properly otherwise. Frankly speaking, I have not looked down the
> calling chain, especially how usb-storage treats these blocks, but I'=
d
> say not at all. Seems like the USB reader, I have, just doesn't get
> the capacity right, by not considering BLOCK_LEN > 512.

Can you run USBMON (see Documentation/usb/usbmon.txt) to capture
the initialization sequence and post that to linux-usb? (CC'd already)


>> b) Do the devices report which SD Card Association spec they are com=
pliant
>> =C2=A0 with in the USB headers?
>>
>> I'm asking (b) to start the conversation about if it's feasible to
>> auto-detect this in the kernel and spare all the distro's from havin=
g
>> to frob the device size.
>>
>> If we can autodetect this case, *and* the device has a valid FAT
>> partition, it should be trivial
>> to use the FAT partition info instead of what the USB card reader is
>> reporting. Partitioning
>> a new card will probably still need "size" to be writable.
>
> I'm sorry, I can't really answer (b).

I can't either.
But if you post the usbmon output to linux-usb, I suspect someone else =
can.


> Autofixing this doesn't seem possible to me (except for the partition
> trick) as the capacity =3D BLOCK_LEN * BLOCKS. If BLOCK_LEN isn't
> detected correctly, we can't distinguish a 1GB from 2GB card.

Agreed. That's why I'm thinking getting BLOCK_LEN right is more importa=
nt
than hacking the resulting partition size. I'd be surprised if this con=
versation
hasn't already occurred on linux-usb mailing list.

thanks,
grant

ps I've cut/pasted the patch you attached below so linux-usb can see it=
=2E

> Best Regards,
> --
> Fruhwirth Clemens http://clemens.endorphin.org
>

--- linux-2.6.32/block/genhd.c  2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.32-patched/block/genhd.c  2009-12-15 08:49:31.608959038 +=
0100
@@ -865,7 +865,7 @@
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
-static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
+static DEVICE_ATTR(size, S_IRUGO | S_IWUSR, part_size_show, part_size_=
set);
 static DEVICE_ATTR(alignment_offset, S_IRUGO,
disk_alignment_offset_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
--- linux-2.6.32/fs/partitions/check.c  2009-12-03 04:51:21.000000000 +=
0100
+++ linux-2.6.32-patched/fs/partitions/check.c  2009-12-15
08:49:01.063465819 +0100
@@ -219,6 +219,19 @@
        return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
 }

+ssize_t part_size_set(struct device *dev,
+                     struct device_attribute *attr, char *buf, size_t =
len)
+{
+       struct hd_struct *p =3D dev_to_part(dev);
+       char *endp;
+       unsigned long long val =3D simple_strtoull(buf, &endp, 10);
+       if (endp =3D=3D buf)
+               return -EINVAL;
+
+       p->nr_sects =3D val;
+       return len;
+}
+
 ssize_t part_alignment_offset_show(struct device *dev,
                                   struct device_attribute *attr, char =
*buf)
 {
--- linux-2.6.32/include/linux/genhd.h  2009-12-03 04:51:21.000000000 +=
0100
+++ linux-2.6.32-patched/include/linux/genhd.h  2009-12-15
09:18:44.793088778 +0100
@@ -549,6 +549,8 @@

 extern ssize_t part_size_show(struct device *dev,
                              struct device_attribute *attr, char *buf)=
;
+extern ssize_t part_size_set(struct device *dev,
+                            struct device_attribute *attr, char *buf,
size_t len);
 extern ssize_t part_stat_show(struct device *dev,
                              struct device_attribute *attr, char *buf)=
;
 extern ssize_t part_inflight_show(struct device *dev,
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
