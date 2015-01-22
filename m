From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: sc_data_direction and bidi commands
Date: Thu, 22 Jan 2015 11:14:29 +0100
Message-ID: <54C0CD85.4000700@sandisk.com>
References: <54BFD163.4020802@sandisk.com>
 <1421920974.7061.55.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0081.outbound.protection.outlook.com ([207.46.100.81]:60837
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751648AbbAVKOh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2015 05:14:37 -0500
In-Reply-To: <1421920974.7061.55.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/22/15 11:02, Nicholas A. Bellinger wrote:
> On Wed, 2015-01-21 at 17:18 +0100, Bart Van Assche wrote:
>> Although several SCSI LLDs compare sc_data_direction with the value
>> DMA_BIDIRECTIONAL apparently scsi_setup_cmnd() never sets
>> sc_data_direction to the value DMA_BIDIRECTIONAL. Is this behavior on
>> purpose ?
> 
> Yes.  Bi-directional CDBs are signaled using scsi_bidi_cmnd(), and IIRC
> ->sc_data_direction = DMA_TO_DEVICE is set for those cases.

But why is sc_data_direction set to DMA_BIDIRECTIONAL in
scsi_ioctl_reset() in drivers/scsi/scsi_error.c ? I think
scsi_bidi_cmnd() will return false for the SCSI command submitted by
scsi_ioctl_reset() since in this case scmd->request->next_rq == NULL.

Bart.
