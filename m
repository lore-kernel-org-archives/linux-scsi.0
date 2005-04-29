From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: Re: [PATCH] scsi_transport_iscsi.c contexts
Date: Fri, 29 Apr 2005 15:13:32 -0700
Message-ID: <1114812812.19139.23.camel@haakon>
References: <1114646147.20844.37.camel@haakon> <42705449.1030706@us.ibm.com>
	 <1114803919.16658.8.camel@haakon>  <4272A506.7020405@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp811.mail.sc5.yahoo.com ([66.163.170.81]:55631 "HELO
	smtp811.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S263030AbVD2WXX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 18:23:23 -0400
In-Reply-To: <4272A506.7020405@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>

On Fri, 2005-04-29 at 14:20 -0700, Mike Christie wrote:
> >>The reason all the settings are stuck on the session was becuase we couldn't
> >>come to an agreement on the layout. We wanted to do something like this:
> >>
> >>/sys/class/iscsi_session/iscsi_connection
> >>
> >>or even
> >>
> >>/sys/class/iscsi_session
> >>/sys/class/iscsi_connection
> >>
> > 
> > 
> > I am still thinking on this one.  First and foremost I think that we
> > need to get move towards a single class for iSCSI Initiators instead of
> > what is currently registered (/sys/class/iscsi_transport
> > and /sys/class/iscsi_host).  Let me keep working on this some more and I
> > will draft up a prosposal in the near future.  Any futher input is
> > welcomed. :-)
> > 
> 
> get everyone to agree (or force them) on how to set the initiarname and alias
> and the iscsi_host can be chopped. the iscsi_host is only there becuase sfnet
> used a /etc file and I think you can set the initiatorname on some HW cards
> from a BIOS/OF prompt (or you will not have control over it) so if they ever
> end up on the same box and wanted to konw what each one ended up as you could.
> 

Ok, one possible solution is when the iSCSI Template structure gets
registered with the iSCSI Transport, the LLD can tell the transport what
values are already defined.  I think this point really goes back to
previous points about different class attributes need to be dynamicly
registered within the iSCSI Stack when certain events occur.

Considering the following:

1) iscsi_attach_transport() is called when the iSCSI Stack is loaded:

   /sys/class/iscsi_transport/	

	a) Initiator[Name,Alias] is not set.

		The stack will set this value later.

	b) Initiator[Name,Alais] is set.
		
		Assume that ->get_initiator_[name,alias]() will return 
		values from hardware

2) struct iscsi_channel_class *iscsi_attach_channel(struct
scsi_transport_template)

   /sys/class/iscsi_transport/iscsi_$CHANNEL_ID.

	Note that for management purposes that $CHANNEL_ID needs to be a
	value that does not change.  ie: not the SCSI Host ID.

	This registers ALL of the sysfs attributes for both session and 
	connection contexts.  These values are read/write as these are
        values that are used as the defaults when sessions/connections
        are started on said iSCSI Channel.

3) struct iscsi_session_class *iscsi_attach_session(struct
iscsi_channel_class)

   /sys/class/iscsi_transport/iscsi_$CHANNEL_ID/

	This contains the read only attributes that where negoitated 
	after successful session establishment.  Note that some of these
	values need to be write as well. (InitiatorAlias can be changed 
	after the session is up)

4) struct iscsi_connection_class *iscsi_attach_connection(struct
iscsi_session_class *, unsigned short cid)

   /sys/class/iscsi_transport/iscsi_$CHANNEL_ID/session/connection_$CID

	This contains the read only attributes that where negoitated
	after successful connection establishment.  Note that some of
	these values need to be write as well. 
	(MaxRecvDataSegmentLength can be changed after the connection
	up).

Of course the names would probable get changed around a bit, but I think you get the idea.

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>

