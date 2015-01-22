From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: sc_data_direction and bidi commands
Date: Thu, 22 Jan 2015 02:39:28 -0800
Message-ID: <1421923168.7061.66.camel@haakon3.risingtidesystems.com>
References: <54BFD163.4020802@sandisk.com>
	 <1421920974.7061.55.camel@haakon3.risingtidesystems.com>
	 <54C0CD85.4000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54552 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbbAVKja (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2015 05:39:30 -0500
In-Reply-To: <54C0CD85.4000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2015-01-22 at 11:14 +0100, Bart Van Assche wrote:
> On 01/22/15 11:02, Nicholas A. Bellinger wrote:
> > On Wed, 2015-01-21 at 17:18 +0100, Bart Van Assche wrote:
> >> Although several SCSI LLDs compare sc_data_direction with the value
> >> DMA_BIDIRECTIONAL apparently scsi_setup_cmnd() never sets
> >> sc_data_direction to the value DMA_BIDIRECTIONAL. Is this behavior on
> >> purpose ?
> > 
> > Yes.  Bi-directional CDBs are signaled using scsi_bidi_cmnd(), and IIRC
> > ->sc_data_direction = DMA_TO_DEVICE is set for those cases.
> 
> But why is sc_data_direction set to DMA_BIDIRECTIONAL in
> scsi_ioctl_reset() in drivers/scsi/scsi_error.c ? I think
> scsi_bidi_cmnd() will return false for the SCSI command submitted by
> scsi_ioctl_reset() since in this case scmd->request->next_rq == NULL.
> 

Well, according to DMA-API.txt it's classified as:

   DMA_BIDIRECTIONAL       direction isn't known

and is unrelated to any actual SCSI bidi commands containing both WRITE
and READ payload buffers.

scsi_ioctl_reset() is only generating TMFs btw, and can't inject any
SCSI bidi commands.

--nab

