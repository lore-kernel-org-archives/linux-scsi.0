From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] correct attribute_container list usage
Date: Mon, 22 Aug 2005 15:21:11 -0700
Message-ID: <20050822222111.GA26927@us.ibm.com>
References: <1124723180.5211.25.camel@mulgrave> <20050822214617.GA26441@us.ibm.com> <1124747956.5211.38.camel@mulgrave> <20050822221427.GA26767@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:40911 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751081AbVHVXVf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 19:21:35 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7MN07Zp238250
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 19:21:32 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7MMLJh5346276
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 16:21:19 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7MMLAaN022325
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 16:21:10 -0600
Content-Disposition: inline
In-Reply-To: <20050822221427.GA26767@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 22, 2005 at 03:14:27PM -0700, Patrick Mansfield wrote:

> Attached is a test module, it oopsed for me with CONFIG_DEBUG_SLAB, on
> ppc64. I was trying to complete testing of my hack (on current git tree,
> rather than scsi-misc), but have been preempted by other work today.
> The patch worked OK for rmmod qla2300.

OK ... really attached it this time.

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dev_child.c"

#include <linux/config.h>
#include <linux/module.h>

#include <linux/kernel.h>
#include <linux/sched.h>
#include <linux/errno.h>
#include <linux/timer.h>
#include <linux/types.h>
#include <linux/string.h>
#include <linux/genhd.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/moduleparam.h>

static int dev_child_state = 1;

MODULE_AUTHOR("Patrick Mansfield");
MODULE_DESCRIPTION("test device_for_each_child");
MODULE_LICENSE("GPL");

static struct device dev_child_main, *dev_child_child;

static void some_release(struct device *dev)
{
	printk(KERN_WARNING "enter %s to kfree %s\n", __FUNCTION__,
	       dev->bus_id);
	kfree(dev);
	printk(KERN_WARNING "exit  %s\n", __FUNCTION__);
}

/*
 * Add one device under dev_child_main.
 */
static void dev_child_create(void)
{
	struct device *dev;

	printk(KERN_WARNING "enter %s\n", __FUNCTION__);
	dev = kmalloc(sizeof (*dev), GFP_KERNEL);
	if (!dev) {
		printk(KERN_WARNING "%s can't get dev\n", __FUNCTION__);
		return;
	}
	memset(dev, 0, sizeof(*dev));
	dev->parent = &dev_child_main;
	dev->release = &some_release;
	sprintf(dev->bus_id, "child-1");
	device_register(dev);
	dev_child_child = dev;
	printk(KERN_WARNING "exit  %s, added %s\n", __FUNCTION__,
	       dev->bus_id);
}

/*
 * Remove dev_child_child.
 */
static void dev_child_destroy_ok(void)
{
	printk(KERN_WARNING "enter %s\n", __FUNCTION__);
	if (dev_child_child) {
		get_device(&dev_child_main);
		device_unregister(dev_child_child);
		dev_child_child = NULL;
		put_device(&dev_child_main);
	}
	printk(KERN_WARNING "exit  %s\n", __FUNCTION__);
}

static int remove_child(struct device *dev, void *data)
{
	printk(KERN_WARNING "enter %s\n", __FUNCTION__);
	device_unregister(dev);
	printk(KERN_WARNING "exit  %s\n", __FUNCTION__);
	return 0;
}

/*
 * Remove all children of dev_child_main
 */
static void dev_child_destroy_fails(void)
{
	printk(KERN_WARNING "enter %s\n", __FUNCTION__);
	get_device(&dev_child_main);
	device_for_each_child(&dev_child_main, NULL, remove_child);
	put_device(&dev_child_main);
	dev_child_child = NULL;
	printk(KERN_WARNING "exit  %s\n", __FUNCTION__);
}

static int dev_child_set_state(const char *val, struct kernel_param *kp)
{
	int new_state;

	switch(val[0]) {
	case '0':
		new_state = 0;
		break;
	case '1':
		new_state = 1;
		break;
	case '2':
		new_state = 2;
		break;
	default:
		return -EINVAL;
	}

	if (new_state != dev_child_state) {
		dev_child_state = new_state;
		if (dev_child_state == 0)
			dev_child_create();
		else if (dev_child_state == 1)
			dev_child_destroy_ok();
		else /* 2 */
			dev_child_destroy_fails();
		return 0;
	} else
		return -E2BIG;

	return 0;
}

module_param_call(state, dev_child_set_state, param_get_int,
		                    &dev_child_state, 0644);

static void dev_child_0_release(struct device * dev)
{
}

static struct device dev_child_primary = {
	.bus_id		= "pseudo-dev_child",
	.release	= dev_child_0_release,
};

static int dev_child_bus_match(struct device *dev,
                          struct device_driver *dev_driver)
{
        return 1;
}

static struct bus_type dev_child_bus = {
        .name = "dev_child_bus",
        .match = dev_child_bus_match,
};

static int dev_child_probe(struct device *dev)
{
	int error = 0;

	return error;
}

static int dev_child_remove(struct device *dev)
{
	int error = 0;

	dev_child_destroy_ok();
	return error;
}

static struct device_driver dev_child_sys_driver = {
	.name           = "dev_child",
	.bus            = &dev_child_bus,
	.probe          = dev_child_probe,
	.remove         = dev_child_remove,
};

static void dev_child_release(struct device *dev)
{
}

static void add_main(void)
{
	struct device *dev = &dev_child_main;
	int error;

	/* add one device to our pseudo bus */
	device_initialize(dev);
	dev->bus = &dev_child_bus;
	dev->parent = &dev_child_primary;
	dev->release = &dev_child_release;
	strcpy(dev->bus_id, "dev_child_main");

	error = device_register(dev);
	if (error)
		printk(KERN_WARNING "%s device_register failed %d\n",
		       __FUNCTION__, error);
}

static void remove_main(void)
{
	device_unregister(&dev_child_main);
}

static int __init dev_child_init(void)
{
	int err;

	err = device_register(&dev_child_primary);
	if (err) {
		printk(KERN_WARNING "%s: device_register failed %d\n",
		      __FUNCTION__, err);
		goto fail1;
	}
	err = bus_register(&dev_child_bus);
	if (err) {
		printk(KERN_WARNING "%s: bus_register failed %d\n",
		      __FUNCTION__, err);
		goto fail2;
	}
	err = driver_register(&dev_child_sys_driver);
	if (err) {
		printk(KERN_WARNING "%s: driver_register failed %d\n",
		      __FUNCTION__, err);
		goto fail3;
	}

	add_main();
	return 0;

fail3:
	bus_unregister(&dev_child_bus);
fail2:
	device_unregister(&dev_child_primary);
fail1:
	return err;
}

static void __exit dev_child_exit(void)
{
	remove_main();
	driver_unregister(&dev_child_sys_driver);
	bus_unregister(&dev_child_bus);
	device_unregister(&dev_child_primary);
}

device_initcall(dev_child_init);
module_exit(dev_child_exit);

--Dxnq1zWXvFF0Q93v--
