From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [ANNOUNCE] Emulex lpfcdriver v8.0.7 available
Date: Mon, 26 Jul 2004 14:44:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040726134450.GA25645@infradead.org>
References: <20040723211529.GQ20738@ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:54401 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265119AbUGZNox (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2004 09:44:53 -0400
Content-Disposition: inline
In-Reply-To: <20040723211529.GQ20738@ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

looking at your lun/target handling changes a little more:

 - lpfc_find_target can lose it's last two arguments
 - lpfc_findnode_scsiid can be merged into lpfc_find_target,
   killing lots of dead checks.
 - it looks like all the callers of lpfc_find_target in lpfc_hbadisc.c
   realy want to be scsi_add_device calls, which calls lpfc_slave_alloc
   meaning lpfc_find_target could be merged into that one.
 - similarly your statemachine should probably call scsi_remove_device
   when a target disappears.
