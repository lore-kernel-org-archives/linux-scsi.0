From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 1/4] [SCSI]stex: fix id mapping issue
Date: Wed, 04 Apr 2007 12:35:39 -0500
Message-ID: <1175708139.3693.39.camel@mulgrave.il.steeleye.com>
References: <B70A50D07063384EB9BCE3330D18414F0327ED0C@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752105AbXDDRfs@vger.kernel.org>
In-Reply-To: <B70A50D07063384EB9BCE3330D18414F0327ED0C@nonameb.ptu.promise.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-04-04 at 10:31 -0700, Ed Lin wrote:

> Sorry. It seems the mail server has problem. The patch is here in plain
> text. I hope this time it does not mess up. I have problem with
> linux-scsi
> mail list, if you have comment please cc me. Thanks.
> --Ed Lin

The lines are still broken, I'm afraid ... you can just resend as an
attachement git-applypatch copes fine with that ... inline is just good
for quoting and replying.
> +	if (hba->cardtype == st_shasta) {
> +		host->max_channel = 7;
> +		host->max_id = 16 + 1;
> +	} else if (hba->cardtype == st_yosemite) {
> +		host->max_channel = 127;
> +		host->max_id = 1 + 1;
> +	} else {
> +		/* st_vsc and st_vsc1 */
> +		host->max_channel = 0;
> +		host->max_id = 128 + 1;

This is OK.  The use of ->channel is still a bit strange ... could we
not simply use lun instead of channel (i.e. map the adapter id/lun to
the mid-layer id/lun instead of using id/channel)?

James
