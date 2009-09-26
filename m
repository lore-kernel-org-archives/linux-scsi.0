From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: badly-named non-Kconfig variables in drivers/scsi/arm
Date: Sat, 26 Sep 2009 08:08:49 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0909260805460.18872@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:47971 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZIZMIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Sep 2009 08:08:47 -0400
Received: from cpe002129687b04-cm001225dbafb6.cpe.net.cable.rogers.com ([99.235.241.187] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1MrW54-0005RW-Nl
	for linux-scsi@vger.kernel.org; Sat, 26 Sep 2009 08:08:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


  part of the output from a scanning script of mine that searches for
references to alleged Kconfig variables that don't actually exist:

>>>>> ACORNSCSI_CONSTANTS
drivers/scsi/arm/acornscsi.c:106:#undef CONFIG_ACORNSCSI_CONSTANTS
drivers/scsi/arm/acornscsi.c:414:#ifdef CONFIG_ACORNSCSI_CONSTANTS
drivers/scsi/arm/acornscsi.c:492:#ifdef CONFIG_ACORNSCSI_CONSTANTS
>>>>> SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:70:#undef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:164:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:1672:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:2827:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
drivers/scsi/arm/acornscsi.c:2858:#ifdef CONFIG_SCSI_ACORNSCSI_LINK

  the problem is with the "CONFIG_" prefix being used for macro names
that aren't actually Kconfig variables.  coding style dictates that
anything that starts with "CONFIG_" should be defined in a Kconfig
file somewhere, so either:

1) those two variables should be defined as such, or
2) they can be renamed (just by dropping the CONFIG_ prefix) so as not
to pollute the Kconfig namespace.

  thoughts?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
