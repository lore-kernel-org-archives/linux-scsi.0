From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Discussion about SCST sysfs layout and	implementation.
Date: Tue, 28 Apr 2009 21:02:43 +0400
Message-ID: <49F736B3.9090205@vlnb.net>
References: <49E7307A.8000205@vlnb.net> <49E77795.7080204@linux.vnet.ibm.com> 	<49E85F1C.7040106@vlnb.net> <49E8832F.6070302@linux.vnet.ibm.com> 	<49E88E3F.8030107@vlnb.net> <49E891C8.1050007@emulex.com> 	<49E8BFB2.50608@vlnb.net>	<ac3eb2510904171056v4c6c971dx99bfb87464a6b02d@mail.gmail.com> <ac3eb2510904171124h11c4c70bu371fa06127cb45da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090607060505020608090309"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57228 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761761AbZD1RC3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2009 13:02:29 -0400
In-Reply-To: <ac3eb2510904171124h11c4c70bu371fa06127cb45da@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "scst-devel@lists.sourceforge.net" <scst-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daniel Debonzi <debonzi@linux.vnet.ibm.com>, James Smart <James.Smart@emulex.com>

This is a multi-part message in MIME format.
--------------090607060505020608090309
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Kay Sievers, on 04/17/2009 10:24 PM wrote:
> On Fri, Apr 17, 2009 at 19:56, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On Fri, Apr 17, 2009 at 19:43, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>> Thank you for the suggestion. If nobody objects, we will go with
>>> /sys/class/scst_tgt.
>> On Fri, Apr 17, 2009 at 19:43, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>> I agree, looks like using struct device instead of struct kobject should
>>> additionally complicate the code a lot for not clear gain.
>> Thes both replies together suggest that you miss how sysfs and the
>> driver core works. Please go and read the current code, and look at
>> sysfs, before trying anything like this.
>>
>> There is no way to add any stuff to /sys/class/scst_tgt/ without using
>> proper "struct device" objects.
>>
>> For the same reason we will not have a disconnected device tree, we
>> will not havet any raw kobject in the /sys/devices, /sys/class,
>> /sys/bus directories.
> 
> As a starting point, consider creating a "scst" bus_type. Then make
> sure all devices you need are uniquely named, so they can be in a flat
> list in /sys/bus/scst/devices/.
> 
> Then add all the devices as struct_device to the tree, maybe use an
> existing parent struct_device (like a pci device) if you have one, or
> create a custom one in /sys/devices/ if there is nothing to use.
> 
> All the devices you add will show up in a hierarchy in /sys/devices/
> depending on the parent information you supply, and every single
> device of your subsystem will be listed in a flat list in
> /sys/bus/scst/devices/*. You will also get proper events for userspace
> that way.
> 
> The question is where the actual block devices hang off, and if they
> can use one of the created scst devices, or if they will be virtual
> ones?

After some deep sysfs digging I agree, /sys/class/scst_tgt isn't too 
good place, because SCST as a SCSI subsystem doesn't deal with "devices" 
in the common Linux understanding of this term. Instead, it deals with 
objects, which shouldn't be seen by user space as devices. Closer 
analogy for them is something like NFS exports [1].

What SCST sysfs interface needs is to direct export of internal data 
structures, their attributes and the linkages between them to user 
space. Seems, the appropriate place for such objects is /sys/kernel/. 
So, will /sys/kernel/scst_tgt/ be a good root of the SCST sysfs 
hierarchy? The content of it will remain the same as I described in the 
first e-mail of this thread.

Internal implementation will be based on kobject's and kobj_attribute's 
as in the prototype, developed by Daniel Debonzi (it so far uses 
/sys/scsi_tgt as a root). The end result should be simple, clear and 
straightforward.

Thanks,
Vlad

[1] As I already wrote, there is very few in common between SCSI target 
and initiator subsystems: only some constants and protocol (hence, name 
"SCSI"). This isn't a limitation of this particular implementation, this 
is fundamental. More details you can find in the middle of 
http://lkml.org/lkml/2008/12/10/245.

--------------090607060505020608090309
Content-Type: text/plain;
 name="scst_sysfs.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scst_sysfs.c"

#include <linux/kobject.h>
#include <linux/string.h>
#include <linux/sysfs.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/ctype.h>

#include "scst.h"
#include "scst_priv.h"
#include "scst_mem.h"

#define SCST_SYSFS_BLOCK_SIZE (PAGE_SIZE - 512)

static DEFINE_MUTEX(scst_sysfs_mutex);

/* struct kobject *targets; */
/* struct kobject *devices; */
/* struct kobject *sgv; */
/* struct kobject *drivers; */

struct scst_sysfs_root {
	struct kobject kobj;
};

struct scst_sysfs_root *scst_sysfs_root;

static ssize_t scst_threads_show(struct kobject *kobj, struct kobj_attribute *attr,
				 char *buf)
{
	int count;

	TRACE_ENTRY();

	count = sprintf(buf, "%d\n", scst_global_threads_count());

	TRACE_EXIT();
	return count;
}


static ssize_t scst_threads_store(struct kobject *kobj, struct kobj_attribute *attr,
				  const char *buf, size_t count)
{
	int res = count;
	int oldtn, newtn, delta;

	TRACE_ENTRY();

	if (count > SCST_SYSFS_BLOCK_SIZE) {
		res = -EOVERFLOW;
		goto out;
	}


	if (mutex_lock_interruptible(&scst_sysfs_mutex) != 0) {
		res = -EINTR;
		goto out;
	}

	mutex_lock(&scst_global_threads_mutex);

	oldtn = scst_nr_global_threads;
	sscanf(buf, "%du", &newtn);

	if (newtn <= 0) {
		PRINT_ERROR("Illegal threads num value %d", newtn);
		res = -EINVAL;
		goto out_up_thr_free;
	}
	delta = newtn - oldtn;
	if (delta < 0)
		__scst_del_global_threads(-delta);
	else
		__scst_add_global_threads(delta);

	PRINT_INFO("Changed cmd threads num: old %d, new %d", oldtn, newtn);

out_up_thr_free:
	mutex_unlock(&scst_global_threads_mutex);

	mutex_unlock(&scst_sysfs_mutex);

out:
	TRACE_EXIT_RES(res);
	return res;
}


static ssize_t scst_trace_level_show(struct kobject *kobj, struct kobj_attribute *attr,
				     char *buf)
{
	return sprintf(buf, "stgt show!!\n");
}


static ssize_t scst_trace_level_store(struct kobject *kobj, struct kobj_attribute *attr,
				      const char *buf, size_t count)
{
	return count;
}


static ssize_t scst_version_show(struct kobject *kobj, struct kobj_attribute *attr,
				 char *buf)
{
	TRACE_ENTRY();

	sprintf(buf, "%s\n", SCST_VERSION_STRING);

#ifdef CONFIG_SCST_STRICT_SERIALIZING
	strcat(buf, "Strict serializing enabled\n");
#endif

#ifdef CONFIG_SCST_EXTRACHECKS
	strcat(buf, "EXTRACHECKS\n");
#endif

#ifdef CONFIG_SCST_TRACING
	strcat(buf, "TRACING\n");
#endif

#ifdef CONFIG_SCST_DEBUG
	strcat(buf, "DEBUG\n");
#endif

#ifdef CONFIG_SCST_DEBUG_TM
	strcat(buf, "DEBUG_TM\n");
#endif

#ifdef CONFIG_SCST_DEBUG_RETRY
	strcat(buf, "DEBUG_RETRY\n");
#endif

#ifdef CONFIG_SCST_DEBUG_OOM
	strcat(buf, "DEBUG_OOM\n");
#endif

#ifdef CONFIG_SCST_DEBUG_SN
	strcat(buf, "DEBUG_SN\n");
#endif

#ifdef CONFIG_SCST_USE_EXPECTED_VALUES
	strcat(buf, "USE_EXPECTED_VALUES\n");
#endif

#ifdef CONFIG_SCST_ALLOW_PASSTHROUGH_IO_SUBMIT_IN_SIRQ
	strcat(buf, "ALLOW_PASSTHROUGH_IO_SUBMIT_IN_SIRQ\n");
#endif

#ifdef CONFIG_SCST_STRICT_SECURITY
	strcat(buf, "SCST_STRICT_SECURITY\n");
#endif

	TRACE_EXIT();
	return strlen(buf);

}


struct kobj_attribute scst_threads_attr = 
	__ATTR(threads, S_IRUGO | S_IWUSR, scst_threads_show, scst_threads_store);

struct kobj_attribute scst_trace_level_attr = 
	__ATTR(trace_level, S_IRUGO | S_IWUSR, scst_trace_level_show, scst_trace_level_store);


struct kobj_attribute scst_version_attr = 
	__ATTR(version, S_IRUGO, scst_version_show, NULL);

	
static struct attribute *scst_sysfs_root_default_attrs[] = {
	&scst_threads_attr.attr,
	&scst_trace_level_attr.attr,
	&scst_version_attr.attr,
	NULL,
};

static void scst_sysfs_root_release(struct kobject *kobj)
{
	kfree(scst_sysfs_root);
}

static ssize_t scst_show(struct kobject *kobj, struct attribute *attr,
			 char *buf)
{
	struct kobj_attribute *kobj_attr;
	kobj_attr = container_of(attr, struct kobj_attribute, attr);

	return kobj_attr->show(kobj, kobj_attr, buf);
}

static ssize_t scst_store(struct kobject *kobj, struct attribute *attr,
			  const char *buf, size_t count)
{
	struct kobj_attribute *kobj_attr;
	kobj_attr = container_of(attr, struct kobj_attribute, attr);

	return kobj_attr->store(kobj, kobj_attr, buf, count);
}

struct sysfs_ops scst_sysfs_root_kobj_ops = {
        .show = scst_show,
        .store = scst_store,
};


static struct kobj_type scst_sysfs_root_ktype = {
	.sysfs_ops = &scst_sysfs_root_kobj_ops,
	.release = scst_sysfs_root_release,
	.default_attrs = scst_sysfs_root_default_attrs,
};

int __init scst_sysfs_init(void)
{
	int retval = 0;

	TRACE_ENTRY();

	scst_sysfs_root = kzalloc(sizeof(*scst_sysfs_root), GFP_KERNEL);
	if(!scst_sysfs_root)
		goto sysfs_root_error;

	retval = kobject_init_and_add(&scst_sysfs_root->kobj,
			&scst_sysfs_root_ktype, NULL, "%s", "scsi_tgt");
	if (retval) 
		goto sysfs_root_kobj_error;

out:	
	TRACE_EXIT_RES(retval);
	return retval;

sysfs_root_kobj_error:
	kfree(scst_sysfs_root);

sysfs_root_error:
	retval = -EINVAL;
	goto out;
}

void __exit scst_sysfs_cleanup(void)
{
	TRACE_ENTRY();

	kobject_put(&scst_sysfs_root->kobj);

	TRACE_EXIT();
	return;
}


--------------090607060505020608090309--
