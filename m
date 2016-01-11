From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 01/15] megaraid_sas: Do not allow PCI access during OCR
Date: Mon, 11 Jan 2016 18:02:03 +0100
Message-ID: <5693E00B.4000403@redhat.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-2-git-send-email-Sumit.Saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932358AbcAKRCG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jan 2016 12:02:06 -0500
In-Reply-To: <1450445228-26571-2-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

On 18.12.2015 14:26, Sumit Saxena wrote:
> This patch will do synhronization between OCR function and AEN function using "reset_mutex" lock.
> reset_mutex will be acquire only in first half of the AEN function which issue DCMD. Second half
> of the function calls SCSI API (scsi_add_device/scsi_remove_device) should be out of reset_mutex
> to avoid deadlock between scsi_eh thread and Driver.
>
> During chip reset(inside OCR function), there should not be any PCI access and AEN function
> (which is called in delayed context) may be firirng DCMDs(doing PCI writes) when chip reset is
> happening in parallel which will cause FW fault. This patch will solve the problem by making
> AEN thread and OCR thread mutually exclusive.
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>

You have removed the no more aen_mutex from megasas_instance
later in 5/15 , that's ok for me.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

