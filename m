From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: LSF Papers online?
Date: Tue, 14 Apr 2009 19:39:50 -0600
Message-ID: <49E53AE6.4010803@gmail.com>
References: <49E335BA.3020103@panasas.com>	 <200904141654.24067.bzolnier@gmail.com>	 <20090414175441.5ce1f59d@lxorguk.ukuu.org.uk>	 <200904150009.06539.bzolnier@gmail.com> <1239749357.3638.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43586 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbZDOBkG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2009 21:40:06 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Ltu6d-0004WG-Na
	for linux-scsi@vger.kernel.org; Wed, 15 Apr 2009 01:40:03 +0000
Received: from s0106000c41bb86e1.ss.shawcable.net ([70.76.47.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 01:40:03 +0000
Received: from hancockrwd by s0106000c41bb86e1.ss.shawcable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 01:40:03 +0000
In-Reply-To: <1239749357.3638.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

James Bottomley wrote:
> 
> On a final note about the urgency of getting libata out of SCSI: Intel
> has been worrying for a while about the fatness of the SCSI/libata
> stack, and its effects on performance, especially command transmission
> via SAT, so I'm hoping they'll be supporting the effort.

I really don't see this as being a big driver for this move. If you look 
at the code that does the translation of SCSI commands to ATA commands, 
there really is not much there at all of any consequence to CPU usage. 
Compared to any kind of hardware/controller interactions I wouldn't say 
it's likely to be a significant bottleneck at all. In oprofile runs I've 
done with heavy ATA activity, the top time consumers are the interrupt 
handlers, command issue paths, code that actually is poking IO 
registers. The libata-scsi code hasn't even shown up on the radar in my 
experience.

