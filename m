From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] fix to serialize unload and discovery
Date: Thu, 19 Oct 2006 15:41:04 -0700 (PDT)
Message-ID: <20061019224104.16983.qmail@web31801.mail.mud.yahoo.com>
References: <20061019212048.GA26234@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:11874 "HELO
	web31801.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1946600AbWJSWlH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 18:41:07 -0400
In-Reply-To: <20061019212048.GA26234@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org

--- malahal@us.ibm.com wrote:
> Lubin, I am not sure if you are referring to your version of the driver
> or the mainline version!

Malahal,

I'm not referring to the bottomleyised version of my code.

> If I read the mainline version correctly,
> sas_deform_port() actually removes a phy from a port and also removes
> all attached devices if it is the last phy in the port.
> 
> When a phy/port is gone, an event is posted to the work queue to
> eventually call sas_deform_port(). Let me know if I misunderstood the
> mainline version.

I'm not sure if you misunderstood the mainline version of my code --
you have to ask bottomley for that, since this code has been appropriated
by bottomley who has also done some "architectural" changes.

Good luck!
    Luben


> 
> Thanks, Malahal.
> 
> Luben Tuikov [ltuikov@yahoo.com] wrote:
> > --- malahal@us.ibm.com wrote:
> > > sas_discover_domain() and sas_deform_port() assume that they are single
> > > threaded and never run in parallel.
> > 
> > This is indeed not true.
> >
> > > That is mostly true as we have a
> > > single threaded work queue to handle discovery and other events.
> > 
> > Hint: when the port is gone, it is gone...
> > 
> > > The
> > > only race I find is unloading a module will call sas_deform_port()
> > > without watching if there is a discovery event is in progress. This
> > > patch will stop queuing further events, flush the queue, and then call
> > > sas_deform_port() to avoid the race.
> > 
> > You need a much more elaborate (read: general solution, aka algorithm)
> > framework to solve this.
> > 
> > Needless to say, I don't observe these bugs and errors in my version
> > of the SAS Stack.
> > 
> >     Luben
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

