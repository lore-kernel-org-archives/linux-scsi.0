From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction
 before starting the request) breaks mtx tape library control
Date: Wed, 19 Jul 2017 10:36:54 +0200
Message-ID: <20170719083654.GE4151@linux-x5ow.site>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
 <20170718073747.GD4875@linux-x5ow.site>
 <ufak235abug.fsf@epithumia.math.uh.edu>
 <20170719070335.GC4151@linux-x5ow.site>
 <ufazic0974h.fsf@epithumia.math.uh.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ufazic0974h.fsf@epithumia.math.uh.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason L Tibbitts III <tibbs@math.uh.edu>, Doug Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 19, 2017 at 03:13:34AM -0500, Jason L Tibbitts III wrote:
> [   46.304530] sg_is_valid_dxfer: dxfer_direction: -2, dxfer_len: 0

Ahh now I see the -2 (SG_DXFER_TO_DEV) is the crucial point here. It is 0 in
your case.

This would "fix" it but I'm not generally sure it is _the_ solution:

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 1e82d4128a84..b421ec81d775 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -764,7 +764,7 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
 		return true;
 	case SG_DXFER_TO_DEV:
 	case SG_DXFER_TO_FROM_DEV:
-		if (!hp->dxferp || hp->dxfer_len == 0)
+		if (!hp->dxferp)
 			return false;
 		return true;
 	case SG_DXFER_UNKNOWN:

Doug, what are the rules for SG_DXFER_TO_{FROM_}DEV? Apparently we can't
be sure len > 0, can we rely on dxferp being present?

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
