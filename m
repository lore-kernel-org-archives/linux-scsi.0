From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 3/6] qla2xxx: Add FC-NVMe F/W initialization and
 transport registration
Date: Thu, 22 Jun 2017 20:53:05 +0200
Message-ID: <20170622185305.GB3284@linux-x5ow.site>
References: <20170621204846.21663-1-himanshu.madhani@cavium.com>
 <20170621204846.21663-4-himanshu.madhani@cavium.com>
 <20170622094649.GD5670@linux-x5ow.site>
 <2d07d1fd-545b-0308-8a2b-5cfb59cbcf2b@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53966 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752669AbdFVSxM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 14:53:12 -0400
Content-Disposition: inline
In-Reply-To: <2d07d1fd-545b-0308-8a2b-5cfb59cbcf2b@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: "Madhani, Himanshu" <himanshu.madhani@cavium.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, darren.trapp@cavium.com, giridhar.malavali@cavium.com, linux-nvme@lists.infradead.org

On Thu, Jun 22, 2017 at 10:48:46AM -0700, James Smart wrote:
> He can't move it. the fcport->nvme_remote_port pointer is set by the
> nvme_fc_register_remoteport() routine (if return status is 0).

Gah, that's kind of wired. Literly _all_ of the Kernel's register_xxx()
funtions have a semantic that after the registration is done the object can be
used and thus assigning private pointer afterwards is an error. Damn I didn't
realize this in the nmve-fc review.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
