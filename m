From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC][PATCH 2/6] fnic: add fnic_scsi.c and fnic_io.h.
Date: Mon, 25 Aug 2008 15:39:45 -0400
Message-ID: <48B30A81.9020406@emulex.com>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com> <20080823025222.13569.37765.stgit@feynman.nuovasystems.com> <48B2F880.7080108@cs.wisc.edu> <48B304BD.9060404@emulex.com> <48B30885.1010808@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42635 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbYHYTkq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2008 15:40:46 -0400
In-Reply-To: <48B30885.1010808@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "jeykholt@cisco.com" <jeykholt@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jre@nuovasystems.com" <jre@nuovasystems.com>, "ajoglekar@nuovasystems.com" <ajoglekar@nuovasystems.com>



Mike Christie wrote:
>> Well - what should be happening is - prior to the reset or as part of
>> it, the fc transport fc_remote_port_delete() call should be made on all
>> those remote ports that connectivity is about to be terminated on.  This
>> will place all the associated targets/luns on those rports into a
>> blocked state, and start the devloss timer on them.  This will suspend
>> the eh path as well.  Thus, things suspend until either the driver/fcoe
> 
> What do you mean by that? For lpfc it will or for this driver? This
> driver does not have that block call like lpfc_block_error_handler, so
> if the rport event occurs after the scsi eh is running we do not suspend
> the eh.
> 
> So below I am saying we should make the lpfc_block_error_handler
> functionality and the equivalent in the qla2xxx and mpfc common so
> libfc/fcoe and fnic can use it.

Well there's successive layers of the onion here. And your right, one of 
them is the block_error_handler.  Agreed, all of this should be common.

-- james s

