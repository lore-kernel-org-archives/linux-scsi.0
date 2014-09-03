From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Wed, 03 Sep 2014 15:07:34 -0700
Message-ID: <1409782054.6571.27.camel@jarvis.lan>
References: <Pine.LNX.4.44L0.1409031625040.2156-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1409031625040.2156-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: "Dale R. Worley" <worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org>, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-09-03 at 16:30 -0400, Alan Stern wrote:
> On Wed, 3 Sep 2014, James Bottomley wrote:
> 
> > Before we embark on elaborate hacks, why don't we just make the capacity
> > writeable (by root) in sysfs from userspace (will require block change)?
> > We can then encode all the nasty heuristics (including gpt reading) in
> > userspace as a udev rule.
> 
> That's what I'm working on.  Except that I don't know where to do it in
> the block layer, so for now I'm adding the attribute to sd.c.
> 
> Where in the block layer would the right place be?  We want this to
> apply only to entire devices, not to individual partitions.

The bottom layer for this is part0.nr_sects which is the size attribute
you see in the block sysfs.  However, it looks like we keep a separate
value in sdkp, but we don't ever seem to use it (except to see if the
capacity has changed).

So this could be done in two ways: add a writeable capacity attribute in
sd.c, as you were originally thinking (it would call set_capacity() on
write and that would update the block layer) or make the size parameter
writeable.

This is how you would do the block layer one below, but there's no way
to inform the lower layer (so it better not have any information cached
that it makes use of).

James

---
diff --git a/block/genhd.c b/block/genhd.c
index 791f419..a114636 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -980,7 +980,7 @@ static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
-static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
+static DEVICE_ATTR(size, S_IRUGO|S_IWUSR, part_size_show, part_size_store);
 static DEVICE_ATTR(alignment_offset, S_IRUGO, disk_alignment_offset_show, NULL);
 static DEVICE_ATTR(discard_alignment, S_IRUGO, disk_discard_alignment_show,
 		   NULL);
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 789cdea..d0cc418 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -87,6 +87,20 @@ ssize_t part_size_show(struct device *dev,
 	return sprintf(buf, "%llu\n",(unsigned long long)part_nr_sects_read(p));
 }
 
+ssize_t part_size_store(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	u64 size;
+
+	if (count > 0 && sscanf(buf, "%llu", &size) > 0)
+		part_nr_sects_write(p, size);
+	else
+		return -EINVAL;
+
+	return count;
+}
+
 static ssize_t part_ro_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index ec274e0..c9b3473 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -628,6 +628,9 @@ extern void blk_unregister_region(dev_t devt, unsigned long range);
 
 extern ssize_t part_size_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
+extern ssize_t part_size_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count);
 extern ssize_t part_stat_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
 extern ssize_t part_inflight_show(struct device *dev,


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
