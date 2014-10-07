From: Mark Knibbs <markk@clara.co.uk>
Subject: Off-by-one LUN validation in scsi_scan_host_selected()?
Date: Tue, 7 Oct 2014 22:08:58 +0100
Message-ID: <20141007220858.f256d6a7c54f6dc1a71ffab4@clara.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:42551 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbaJGVgw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2014 17:36:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

In drivers/scsi_scsi_scan.c, we have:

int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
			    unsigned int id, u64 lun, int rescan)
	...
	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
		return -EINVAL;
	...

The max_lun field of the Scsi_Host structure (see include/scsi/scsi_host.h)
seems to be defined as the actual maximum LUN plus 1:
	 * These three parameters can be used to allow for wide scsi,
	 * and for host adapters that support multiple busses
	 * The first two should be set to 1 more than the actual max id
	 * or lun (e.g. 8 for SCSI parallel systems).
	 */
	unsigned int max_channel;
	unsigned int max_id;
	u64 max_lun;

[The comment has a typo; it refers to the max_id and max_lun fields as the
first two, but they are the last two.]

Shouldn't the LUN check in scsi_scan_host_selected() be
(lun >= shost->max_lun)?


Mark
