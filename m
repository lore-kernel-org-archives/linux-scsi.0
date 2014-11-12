From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 02/10] scsi: Add SPC-3 command definitions
Date: Wed, 12 Nov 2014 17:07:37 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959398D0C@G9W0745.americas.hpqcorp.net>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
 <1415262639-121586-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:9794 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaKLRIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 12:08:18 -0500
In-Reply-To: <1415262639-121586-3-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, 06 November, 2014 2:31 AM
> To: James Bottomley
> Cc: Christoph Hellwig; Ewan Milne; Elliott, Robert (Server Storage);
> linux-scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 02/10] scsi: Add SPC-3 command definitions
> 
> SPC-3 defines SERVICE ACTION IN(12), SERVICE_ACTION OUT(12),
> SERVICE ACTION OUT(16), and SERVICE ACTION BIDIRECTIONAL.
> And READ MEDIA SERIAL NUMBER has long since been deprecated.
> So update callers to refer to the new cdb name.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/constants.c           | 4 ----
>  drivers/target/target_core_pr.c    | 2 +-
>  include/scsi/scsi.h                | 6 +++++-
>  tools/lib/traceevent/plugin_scsi.c | 5 ++++-
>  4 files changed, 10 insertions(+), 7 deletions(-)
> 
...
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index b354c0d..df00fd1 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -128,8 +128,10 @@ enum scsi_timeouts {
>  #define MOVE_MEDIUM           0xa5
>  #define EXCHANGE_MEDIUM       0xa6
>  #define READ_12               0xa8
> +#define SERVICE_ACTION_OUT_12 0xa9
>  #define WRITE_12              0xaa
> -#define READ_MEDIA_SERIAL_NUMBER 0xab
> +#define READ_MEDIA_SERIAL_NUMBER 0xab /* Obsolete with SPC-2 */
> +#define SERVICE_ACTION_IN_12 0xab

That needs one more space before 0xab to line up with the others.

...
> diff --git a/tools/lib/traceevent/plugin_scsi.c
> b/tools/lib/traceevent/plugin_scsi.c
> index c699f47..63aba97 100644
> --- a/tools/lib/traceevent/plugin_scsi.c
> +++ b/tools/lib/traceevent/plugin_scsi.c
> @@ -85,8 +85,9 @@ typedef unsigned int u32;
>  #define MOVE_MEDIUM			0xa5
>  #define EXCHANGE_MEDIUM			0xa6
>  #define READ_12				0xa8
> +#define SERVICE_ACTION_out_12		0xa9
...

out should be capitalized

Reviewed-by: Robert Elliott <elliott@hp.com>


