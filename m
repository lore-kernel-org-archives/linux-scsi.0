From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Cbe-oss-dev] Playstation 3 BD-ROM access and
	LV1_DENIED_BY_POLICY
Date: Mon, 06 Aug 2007 09:09:39 -0500
Message-ID: <1186409379.3436.3.camel@localhost.localdomain>
References: <46B1F92C.8030206@am.sony.com>
	 <1186072148.13194.46.camel@haakon2.linux-iscsi.org>
	 <20070803110537.A84C.MOKUNO@sm.sony.co.jp>
	 <1186133997.3198.19.camel@haakon2.linux-iscsi.org>
	 <46B3770E.4070805@am.sony.com>
	 <Pine.LNX.4.62.0708061533230.31116@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54078 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762192AbXHFOJm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Aug 2007 10:09:42 -0400
In-Reply-To: <Pine.LNX.4.62.0708061533230.31116@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Nicholas A. Bellinger" <nab@kernel.org>, Geoff Levand <geoffrey.levand@am.sony.com>, Masakazu Mokuno <mokuno@sm.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org

On Mon, 2007-08-06 at 15:38 +0200, Geert Uytterhoeven wrote:
> On Fri, 3 Aug 2007, Geoff Levand wrote:
> > Nicholas A. Bellinger wrote:
> > > Thank you for this information.  I since been able to resolve my issue
> > > on 2.6.16 (which ended up being my fault), and was able to determine
> > > that the issue on 2.6.23-rc1 is due to
> > > drivers/scsi/scsi_lib.c:scsi_execute_async() rejecting READ_10 and
> > > TEST_UNIT_READY commands in certain cases (perhaps a race in
> > > drivers/scsi/ps3rom.c..?) using this API that was causing the win32 side
> > > to throw exceptions.
> > 
> > If you get more info on what was happening here, please report it to Geert
> > so he can investigate.  He should return next week.
> 
> Indeed.
> 
> Perhaps because ps3rom cannot queue more than 1 command?
> I'm CCing the SCSI guys, just in case this rings a bell.

Without details, it's really hard to speculate.  The problem description
is manifestly strange for two reasons

     1. READ_10 should never be issued via scsi_execute_async.  There's
        no ULD in the current kernel that does this.  The READ_X/WRITE_X
        commands are issued through the filesystem path.
     2. There's no command filter in there either:  I can imagine an eh
        problem where the LLD isn't accepting the TUR because it still
        thinks the just recovered command is outstanding.

So could we have some actual details?

James


