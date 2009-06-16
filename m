From: Madhavi Manchala <madhavi.lscsi@gmail.com>
Subject: About SCSI INQUIRY command
Date: Tue, 16 Jun 2009 13:03:17 +0530
Message-ID: <97a757510906160033r4245c9aan2eac3d4dc1e45765@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:38414 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZFPHdP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 03:33:15 -0400
Received: by pxi27 with SMTP id 27so778106pxi.33
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 00:33:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear All,

I'm developing a USB class driver for UAS device. I have modified the
storage driver code as per my custom driver requirements. As a part of
this, I have registered to the scsi layer through following snippet in
the storage_probe function. I have seen the code in one of the SAS
driver's implementation.


static DECLARE_TRANSPORT_CLASS(host_class,
		"uas_host", NULL, NULL, NULL);

/*
 * Register transport class with SCSI layer
*/
error = transport_class_register(&host_class);
if (error)
	goto BadDevice;

/*
 * Attach transport template to SCSI layer
 * which shall be used for executing tasks and
 * task management functions.
 */
transport_template = domain_attach_transport(&transport_functions);
if (!transport_template)
	goto BadDevice;

/* Associate transport template to SCSI host transport template */
host->transportt = transport_template;
host->max_id = ~0;
host->max_lun = ~0;

struct scsi_transport_template *
attach_transport(void)
{
	struct uas_internal *i;

	i = kzalloc(sizeof(struct uas_internal), GFP_KERNEL);
	if (!i)
		return NULL;

	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
	i->t.host_attrs.ac.class = &host_class.class;
	i->t.host_attrs.ac.match = uas_host_match;
	transport_container_register(&i->t.host_attrs);
	i->t.host_size = sizeof(struct uas_host_attrs);

	return &i->t;
}

struct scsi_transport_template *
domain_attach_transport(struct domain_function_template *dft)
{
	struct scsi_transport_template *stt = attach_transport();

	if (!stt)
		return stt;

	i = to_uas_internal(stt);
	i->dft = dft;
	stt->create_work_queue = 1;
	stt->eh_timed_out = uas_scsi_timed_out;
	stt->eh_strategy_handler = uas_scsi_recover_host;

	return stt;
}

When I insert the device I am able to see the disk drive (fdisk -l).
However, I am continuously getting the following statements
infinitely. I get the INQUIRY command continuously with "Bad Target
Number". For normal usb-storage devices I get this message 7 times and
stops and get the next command like TEST_UNIT_READY.

<scsi_get_command> invoked!
<__scsi_get_command> invoked!
<scsi_dispatch_cmd> invoked!
<drivers/usb/storage/scsiglue.c> <queuecommand> Entry!
<usb_stor_show_command> Entry. Command INQUIRY (6 Bytes)!
Command INQUIRY (6 bytes)
 12 00 00 00 24 00
<drivers/usb/storage/scsiglue.c> <queuecommand> Exit!
*** thread awakened
Bad target number (1400:0)
scsi cmd done, result=0x40000
*** thread sleeping
<scsi_finish_command> invoked!

Please suggest me where am I doing wrong. Do I need any other ways to
register the transport layer to SCSI layer.

Any suggestion would help me and it would be appreciated.

Thanks and Regards,
Madhavi M
