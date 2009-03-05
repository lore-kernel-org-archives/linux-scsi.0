From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 09/15] NULL noise: drivers/scsi/FlashPoint.c
Date: Thu, 05 Mar 2009 21:58:53 +0000
Message-ID: <1236290333.5626.78.camel@localhost.localdomain>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
	 <20090305191602.30062.71301.stgit@f10box.hanneseder.net>
	 <1236283546.5626.45.camel@localhost.localdomain>
	 <154e089b0903051215q1216aa53icd41556e2af8b234@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39878 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476AbZCEV66 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 16:58:58 -0500
In-Reply-To: <154e089b0903051215q1216aa53icd41556e2af8b234@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Eder <hannes@hanneseder.net>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2009-03-05 at 21:15 +0100, Hannes Eder wrote:
> On Thu, Mar 5, 2009 at 9:05 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Thu, 2009-03-05 at 20:16 +0100, Hannes Eder wrote:
> >> Fix this sparse warnings:
> >>   drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as NULL pointer
> >>   drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer as NULL pointer
> >>   drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as NULL pointer
> >>
> >> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> >> ---
> >> v2: fix checkpatch.pl issue.
> >> v2.1: other subject, as suggested by Al Viro
> >>
> >>  drivers/scsi/FlashPoint.c |    7 +++----
> >>  1 files changed, 3 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
> >> index b898d38..9eb2e86 100644
> >> --- a/drivers/scsi/FlashPoint.c
> >> +++ b/drivers/scsi/FlashPoint.c
> >> @@ -903,8 +903,8 @@ static void FPT_autoCmdCmplt(unsigned long p_port, unsigned char p_card);
> >>  static void FPT_autoLoadDefaultMap(unsigned long p_port);
> >>
> >>  static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] =
> >> L-    { {{0}} };
> >> -static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {0} };
> >> +    { { {NULL} } };
> >> +static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {NULL} };
> >>  static SCCBSCAM_INFO FPT_scamInfo[MAX_SCSI_TAR] = { {{0}} };
> >>  static struct nvram_info FPT_nvRamInfo[MAX_MB_CARDS] = { {0} };
> >
> > This doesn't look right:  {0} as a structure initialiser is a C
> > convention for zero fill this structure; sparse should recognise this.
> > Of course, since these structures are static, they should be in BSS
> > anyway ...
> 
> So a proper fix is just not to initialize the variables.

That works ... and probably also teach sparse to recognise {0}.

> ... and report this issue to the sparse mailing list.
> 
> >
> >> @@ -918,8 +918,7 @@ static unsigned char FPT_scamHAString[] =
> >>
> >>  static unsigned short FPT_default_intena = 0;
> >>
> >> -static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) = {
> >> -0};
> >> +static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) = {NULL};
> >>
> >>  /*---------------------------------------------------------------------
> >>   *
> 
> Same her, right?

I had to look that one up, but yes, it appears {0} does zero initialise
an array as well.

James


