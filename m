From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Autosense requirement
Date: Mon, 29 Jul 2002 16:18:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020729161846.A4342@eng2.beaverton.ibm.com>
References: <3D453CE8.5A15FCD6@splentec.com> <3D457FF3.C7A02C57@torque.net> <20020729155518.B20905@redhat.com> <20020729145326.A23512@beaverton.ibm.com> <20020729175827.N20905@redhat.com> <20020729151027.A2657@eng2.beaverton.ibm.com> <20020729190048.V20905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e21.nc.us.ibm.com (8.12.2/8.12.2) with ESMTP id g6TNIxRY156982
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2002 19:19:00 -0400
Received: from gateway.beaverton.ibm.com (gateway.beaverton.ibm.com [138.95.180.1])
	by westrelay03.boulder.ibm.com (8.12.3/NCO/VER6.3) with ESMTP id g6TNIxcI021100
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2002 17:18:59 -0600
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway.beaverton.ibm.com (8.10.0.Beta10/8.11.6) with ESMTP id g6TNIre04434
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2002 16:18:53 -0700 (PDT)
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g6TNIkb04668
	for linux-scsi@vger.kernel.org; Mon, 29 Jul 2002 16:18:46 -0700 (PDT)
In-Reply-To: <20020729190048.V20905@redhat.com>; from dledford@redhat.com on Mon, Jul 29, 2002 at 07:00:48PM -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, Jul 29, 2002 at 07:00:48PM -0400, Doug Ledford wrote:
> On Mon, Jul 29, 2002 at 03:10:27PM -0700, Patrick Mansfield wrote:

> I saw the posts you made on this.  I was just getting ready to look 
> at/integrate your scsi_scan.c changes then add on the additional stuff I 
> had in mind.  I thought I saw you say you were forward porting the changes 
> to 2.5.28 so it will apply cleanly.  Once I saw that patch come out I was 
> going to grab it.

I had some 2.5.28/29 problems (I didn't set the new CONFIG_XXX_SERIAL
options, and it took me a bit to realize the system was really booting
even though I didn't see any serial line output), I hope to post the
patch (against 2.5.29, but it will apply to 2.5.28) by Wednesday. 

> > Do you have a tree or such that we can sync up with?
> 
> Not anything available yet (it's too broken right now).
> 
> > Any moderate changes to scsi will likely affect the multi-path changes.
> 
> Yep, that I can see for sure...

I have some patches from the multi-path that I could break out, especially
some list iterators -  multi-path needs the Scsi_Device separated from
Scsi_Host. Iterators were added so the underlying structures are not
visible - that is, so host_queue is not directly referenced, and I can
put any type of data structure in its place. This is one of the broadest
changes (potentially affects all adapter drivers) in the multi-path patch.

Having Scsi_Device on its own list could also help in hot-replacement
of single pathed devices (Scsi_Host can be removed without having to
remove a Scsi_Device off of its host_queue).

If you make changes in the host/device list(s) please consider that I need
to have the Scsi_Devices on their own list separate from the Scsi_host list.

Thanks.

-- Patrick Mansfield
