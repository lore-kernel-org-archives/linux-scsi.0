From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: Transport Attributes -- attempt#3
Date: Tue, 20 Jan 2004 13:29:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFF3D99DD8.5E349F85-ONC1256E21.0042CE26-C1256E21.00450FCB@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:33993 "EHLO
	mtagate5.de.ibm.com") by vger.kernel.org with ESMTP id S265371AbUATM30 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 07:29:26 -0500
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Martin Hicks <mort@wildopensource.com>, linux-scsi@vger.kernel.org



> I just submitted a new LLD to linux-scsi and Christoph suggested I us=
e
> this patch for setting SCSI bus attributes. I looked through the patc=
hes
> and noticed that these are per device attributes. I need to be able t=
o
> set per SCSI bus attributes. The attributes I would like to be able t=
o
> set include: initiator ID, maximum bus speed, wide enabled/disabled, =
and
> device spinup delay. Would it make sense to create a scsi_bus class o=
r
> something similar for these types of attributes?

I think extending the scheme would be fine, though some of the
attributes that you have mentioned only apply for SPI. There are
other attributes for other transports, e.g. FC link speed, which
could be of interest too.
Taking this a step further, we will probably find useful attributes
for all levels of the <host>:<bus>:<target>:<lun> hierarchy, which
vary for different transport types.
My FCP focussed brain can't help but bring up an example like this:

<host>
      firmware version
      local WWNN
      ...
<bus>
      local WWPN
      S_ID
      port speed
      link speed
      service class
      topology
      ...
<target>
      peer WWPN
      peer WWNN
      D_ID
      ...
<lun>
      FCP_LUN     (though, I still think <lun> should equal FCP_LUN)
      tagged command queueing
      ...

Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
