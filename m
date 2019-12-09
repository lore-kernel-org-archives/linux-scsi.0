Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD553C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 19:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5ECE20836
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 19:20:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNfU25Hd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfLITUv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 14:20:51 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34759 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfLITUv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 14:20:51 -0500
Received: by mail-pf1-f196.google.com with SMTP id n13so7729784pff.1;
        Mon, 09 Dec 2019 11:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rwYNDINDXq4jLd1x+8nU4LIDCr1YuplCHBB7nDAmKY0=;
        b=jNfU25HdEKxQCWoJPPnTJV5FQTl1ykEeFjgu/IrwfBDmb/gGE36lmT4G+CeMu5GXzP
         C2IQ+vHVCSjTwaZg1SaQGx93q3D2CONkIBykdkldCrJRcl67MkxkMwnyfx7nQTvf5TNw
         LgUUAWYwid7bmiyrLyAOQuitQxo43v+FJlCCnZ0wojHy7H/mwfdqp3UeCb9OwaTUFKm2
         i2lBALE2o0IyFxK1Rbc9MQ+PDpGlaM07iOP61LSOow0Kjml6Zj2KTTumZfFksIiSrsQs
         EFoHe+DdOUUXkZOB5pMuUzmmkt8YMXhXfoN8OYvMeoxWaXr3opsDN1qa/uXBHICMJKAf
         1fNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=rwYNDINDXq4jLd1x+8nU4LIDCr1YuplCHBB7nDAmKY0=;
        b=rKKK3ZBwh1O2bHrlmeCyya7aorZht/5HHsRbaJIvK107Gs+pARe8hP5eGoOuAWZKlX
         uM1+l7EjPPXntJZTCL0G/ZXHidKTIGh2ku6vcwwZqDN36bydQoXlpQ/qFX812EgpQaLL
         jhUG/5d0goRQWQuWlAyRuxQDRZKKJi+6opnO8y62nH6fK4kIVUcKcaYgWmcNKWjCC6M9
         BGG2YazYZ/r1Q7lkqoMKuCkqw6asNXqKALBX4GDA3JakdScFQvEA4WMtD0zRQcCTi9Zo
         5r39wJ7VlULfveeVTM1rBkf96NXX+wKJk5x7wP1rvThMlpOpgsn3jYOvF4YhDz+A6ZcS
         0NVQ==
X-Gm-Message-State: APjAAAXRb/ls7grwTehugUFQgP2DhJyWy1BqZJdPB5y8vwy0k/ce1use
        h7L04AyrAWvzsW6twkgBSDE=
X-Google-Smtp-Source: APXvYqxNJDmMkFYNFwR7LU9gMhYklkWtWIvsDuK8TS1k4tbXiILagz7/PEbn0kJHAIK2QNkfbNXhxw==
X-Received: by 2002:a63:d351:: with SMTP id u17mr19924290pgi.84.1575919250376;
        Mon, 09 Dec 2019 11:20:50 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i127sm265933pfe.54.2019.12.09.11.20.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Dec 2019 11:20:49 -0800 (PST)
Date:   Mon, 9 Dec 2019 11:20:48 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/1] hwmon: Driver for temperature sensors on SATA drives
Message-ID: <20191209192048.GA3940@roeck-us.net>
References: <20191209052119.32072-1-linux@roeck-us.net>
 <20191209052119.32072-2-linux@roeck-us.net>
 <c87ca545-d8f1-bf1e-2474-b98a6eb60422@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c87ca545-d8f1-bf1e-2474-b98a6eb60422@acm.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 09, 2019 at 09:08:13AM -0800, Bart Van Assche wrote:
> On 12/8/19 9:21 PM, Guenter Roeck wrote:
> > +static int satatemp_scsi_command(struct satatemp_data *st,
> > +				 u8 ata_command, u8 feature,
> > +				 u8 lba_low, u8 lba_mid, u8 lba_high)
> > +{
> > +	static u8 scsi_cmd[MAX_COMMAND_SIZE];
> > +	int data_dir;
> 
> Declaring scsi_cmd[] static makes an otherwise thread-safe function
> thread-unsafe. Has it been considered to allocate scsi_cmd[] on the stack?
> 
No idea why I declared that variable 'static'. I removed it.

> > +	/*
> > +	 * Inquiry data sanity checks (per SAT-5):
> > +	 * - peripheral qualifier must be 0
> > +	 * - peripheral device type must be 0x0 (Direct access block device)
> > +	 * - SCSI Vendor ID is "ATA     "
> > +	 */
> > +	if (sdev->inquiry[0] ||
> > +	    strncmp(&sdev->inquiry[8], "ATA     ", 8))
> > +		return -ENODEV;
> 
> It's possible that we will need a quirk mechanism to disable temperature
> monitoring for certain ATA devices. Has it been considered to make
> scsi_add_lun() set a flag that indicates whether or not temperatures
> should be monitored and to check that flag from inside this function?
> I'm asking this because an identical strncmp() check exists in
> scsi_add_lun().
> 
I am aware that we may at some point need quirks for some SATA devices.
From my perspective, the place for such quirks would be this driver,
possibly using the ATA ID string in the inquiry data structure and,
if needed, the firmware revision as identifier.

> > +static int satatemp_read(struct device *dev, enum hwmon_sensor_types type,
> > +			 u32 attr, int channel, long *val)
> > +{
> > +	struct satatemp_data *st = dev_get_drvdata(dev);
> 
> Which device does 'dev' represent? What guarantees that the drvdata
> won't be used for another purpose, e.g. by the SCSI core?
> 
'dev' is the hardware monitoring device. The driver data is set in
hwmon_device_register_with_info(); it is the third argument of that
function. It won't be used outside the context of this driver.

> > +/*
> > + * The device argument points to sdev->sdev_dev. Its parent is
> > + * sdev->sdev_gendev, which we can use to get the scsi_device pointer.
> > + */
> > +static int satatemp_add(struct device *dev, struct class_interface *intf)
> > +{
> > +	struct scsi_device *sdev = to_scsi_device(dev->parent);
> > +	struct satatemp_data *st;
> > +	int err;
> > +
> > +	st = kzalloc(sizeof(*st), GFP_KERNEL);
> > +	if (!st)
> > +		return -ENOMEM;
> > +
> > +	st->sdev = sdev;
> > +	st->dev = dev;
> > +	mutex_init(&st->lock);
> > +
> > +	if (satatemp_identify(st)) {
> > +		err = -ENODEV;
> > +		goto abort;
> > +	}
> > +
> > +	st->hwdev = hwmon_device_register_with_info(dev->parent, "satatemp",
> > +						    st, &satatemp_chip_info,
> > +						    NULL);
> > +	if (IS_ERR(st->hwdev)) {
> > +		err = PTR_ERR(st->hwdev);
> > +		goto abort;
> > +	}
> > +
> > +	list_add(&st->list, &satatemp_devlist);
> > +	return 0;
> > +
> > +abort:
> > +	kfree(st);
> > +	return err;
> > +}
> 
> How much does synchronously submitting SCSI commands from inside the
> device probing call back slow down SCSI device discovery? What is the
> impact of this code on systems with a large number of ATA devices?
> 

Interesting question. In general, any SCSI commands would only be executed
for SATA drives since the very first check in satatemp_identify() uses
sdev->inquiriy and aborts if the drive in question is not an ATA drive.
When connected to SATA drives, I measured the execution time of
satatemp_identify() to be between ~900 uS and 1,700 uS on a system with
Ryzen 3900 CPU.

In more detail:
- Time to read VPD page: ~10-20 uS
- Time to execute SMART_READ_LOG/SCT_STATUS_REQ_ADDR: ~140-150 uS
- Time to execute SMART_WRITE_LOG/SCT_STATUS_REQ_ADDR: ~600-1,500 uS
- Time to execute SMART_READ_LOG/SCT_READ_LOG_ADDR: ~100-130 uS

Does that answer your question ?

Please note that I think that this is irrelevant in this context.
The driver is only instantiated if loaded explicitly, so whoever uses it
will be in a position to decide if the benefit of using it will outweigh
its cost.

If instantiation time ever becomes a real problem, for example if someone
with a large number of SATA drives in a system wants to use the driver
and is concerned about instantiation time, we can make the second part
of its registration (ie everything after identifying SATA drives)
asynchronous. That would, however, add a substantial amount of complexity
to the driver, and we should only do it if it is really warranted.

Thanks,
Guenter
