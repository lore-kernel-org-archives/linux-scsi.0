From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 32/32] cxlflash: Fix to avoid potential deadlock on EEH
Date: Tue, 29 Sep 2015 14:40:09 -0500
Message-ID: <D7E92099-CCEE-4D1B-AF24-1397C8DCBDAD@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223197-10153-1-git-send-email-mrochs@linux.vnet.ibm.com> <5609D03D.6010709@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:55042 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbbI2TkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2015 15:40:15 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 29 Sep 2015 13:40:14 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 2816F1FF008B
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 13:31:21 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8TJeC9n6816186
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 12:40:12 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8TJe99e018989
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 13:40:11 -0600
In-Reply-To: <5609D03D.6010709@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 28, 2015, at 6:41 PM, Brian King <brking@linux.vnet.ibm.com> wrote:
> On 09/25/2015 06:19 PM, Matthew R. Ochs wrote:
>> static int write_same16(struct scsi_device *sdev,
>> @@ -433,9 +451,20 @@ static int write_same16(struct scsi_device *sdev,
>> 		put_unaligned_be32(ws_limit < left ? ws_limit : left,
>> 				   &scsi_cmd[10]);
>> 
>> +		/* Drop the ioctl read semahpore across lengthy call */
>> +		up_read(&cfg->ioctl_rwsem);
>> 		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
>> 				      CMD_BUFSIZE, sense_buf, to, CMD_RETRIES,
>> 				      0, NULL);
>> +		down_read(&cfg->ioctl_rwsem);
>> +		rc = check_state(cfg);
>> +		if (rc) {
>> +			dev_err(dev, "%s: Failed state! result=0x08%X\n",
>> +				__func__, result);
>> +			rc = -ENODEV;
> 
> Since check_state only returns 0 or -ENODEV, this is a bit redundant, but not worth redoing the
> patch in my mind.

Agreed. This occurred to me the other day after submitting this patch when I was
reviewing the state locking code. Will look at revising in a future patch.

Thanks again for reviewing.

