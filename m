Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904CCCA9EB6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 12:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70A8B214B2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 12:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405208AbfJWMTa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 08:19:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:55594 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbfJWMT3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Oct 2019 08:19:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 615F3AD1A;
        Wed, 23 Oct 2019 12:19:27 +0000 (UTC)
Date:   Wed, 23 Oct 2019 14:19:24 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Bart Van Assche <Bart.VanAssche@wdc.com>
Cc:     "corbet@lwn.net" <corbet@lwn.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>,
        "pombredanne@nexb.com" <pombredanne@nexb.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tim@cyberelk.net" <tim@cyberelk.net>
Subject: Re: [PATCH resend 3/6] cdrom: wait for tray to close
Message-ID: <20191023121924.GD938@kitsune.suse.cz>
References: <cover.1516985620.git.msuchanek@suse.de>
 <03915a2e64f50ec04ea6d8e6f80e36ecf16e4f0f.1516985620.git.msuchanek@suse.de>
 <1517245546.2687.17.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1517245546.2687.17.camel@wdc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 29, 2018 at 05:05:47PM +0000, Bart Van Assche wrote:
> On Fri, 2018-01-26 at 17:58 +0100, Michal Suchanek wrote:
> > +static int cdrom_tray_close(struct cdrom_device_info *cdi)
> > +{
> > +	int ret;
> > +
> > +	ret = cdi->ops->tray_move(cdi, 0);
> > +	if (ret || !cdi->ops->drive_status)
> > +		return ret;
> > +
> > +	return poll_event_interruptible(CDS_TRAY_OPEN !=
> > +			cdi->ops->drive_status(cdi, CDSL_CURRENT), 500);
> > +}
> > +
> >  static
> >  int open_for_common(struct cdrom_device_info *cdi, tracktype *tracks)
> >  {
> > @@ -1048,7 +1062,9 @@ int open_for_common(struct cdrom_device_info *cdi, tracktype *tracks)
> >  			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
> >  			    cdi->options & CDO_AUTO_CLOSE) {
> >  				cd_dbg(CD_OPEN, "trying to close the tray\n");
> > -				ret = cdo->tray_move(cdi, 0);
> > +				ret = cdrom_tray_close(cdi);
> > +				if (ret == -ERESTARTSYS)
> > +					return ret;
> >  				if (ret) {
> >  					cd_dbg(CD_OPEN, "bummer. tried to close the tray but failed.\n");
> >  					/* Ignore the error from the low
> > @@ -2312,7 +2328,8 @@ static int cdrom_ioctl_closetray(struct cdrom_device_info *cdi)
> >  
> >  	if (!CDROM_CAN(CDC_CLOSE_TRAY))
> >  		return -ENOSYS;
> > -	return cdi->ops->tray_move(cdi, 0);
> > +
> > +	return cdrom_tray_close(cdi);
> >  }
> 
> So this patch changes code that does not wait into code that potentially waits
> forever? Sorry but I don't think that's ideal. Please make sure that after a
> certain time (a few seconds?) the loop finishes.

Unfortunately, a few seconds is NOT sufficinet. I have no idea what is
the upper bound on the time it can take to close the tray taking into
account all hardware implementations like media changers. For the usual
desktop units it takes tens of seconds so you would need to wait minutes
to give some headroom - basically near-eternity.

Thanks

Michal
