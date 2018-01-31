From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: Re: [PATCH resend 3/6] cdrom: wait for tray to close
Date: Wed, 31 Jan 2018 19:20:27 +0100
Message-ID: <20180131192027.070196c1@kitsune.suse.cz>
References: <cover.1516985620.git.msuchanek@suse.de>
        <03915a2e64f50ec04ea6d8e6f80e36ecf16e4f0f.1516985620.git.msuchanek@suse.de>
        <1517245546.2687.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1517245546.2687.17.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "corbet@lwn.net" <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "bp@alien8.de" <bp@alien8.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>, "davem@davemloft.net" <davem@davemloft.net>, linux-doc@
List-Id: linux-scsi@vger.kernel.org

On Mon, 29 Jan 2018 17:05:47 +0000
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

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
> > +			cdi->ops->drive_status(cdi, CDSL_CURRENT),
> > 500); +}
> > +
> >  static
> >  int open_for_common(struct cdrom_device_info *cdi, tracktype
> > *tracks) {
> > @@ -1048,7 +1062,9 @@ int open_for_common(struct cdrom_device_info
> > *cdi, tracktype *tracks) if (CDROM_CAN(CDC_CLOSE_TRAY) &&
> >  			    cdi->options & CDO_AUTO_CLOSE) {
> >  				cd_dbg(CD_OPEN, "trying to close
> > the tray\n");
> > -				ret = cdo->tray_move(cdi, 0);
> > +				ret = cdrom_tray_close(cdi);
> > +				if (ret == -ERESTARTSYS)
> > +					return ret;
> >  				if (ret) {
> >  					cd_dbg(CD_OPEN, "bummer.
> > tried to close the tray but failed.\n"); /* Ignore the error from
> > the low @@ -2312,7 +2328,8 @@ static int
> > cdrom_ioctl_closetray(struct cdrom_device_info *cdi) 
> >  	if (!CDROM_CAN(CDC_CLOSE_TRAY))
> >  		return -ENOSYS;
> > -	return cdi->ops->tray_move(cdi, 0);
> > +
> > +	return cdrom_tray_close(cdi);
> >  }  
> 
> So this patch changes code that does not wait into code that
> potentially waits forever? Sorry but I don't think that's ideal.
> Please make sure that after a certain time (a few seconds?) the loop
> finishes.

The problem is that few seconds does not cut it. We are waiting for a
mechanical tray or CD changer to move. On non-broken hardware the tray
either closes or an error is reported within a few seconds. For the
timeout to not race with the event we are waiting for it must be much
longer, though.

Also note that this code is only invoked when the user specifically
requested that the tray gets closed automatically which is off by
default.

Thanks

Michal
