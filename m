From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Mon, 1 Jul 2013 19:23:25 +0000
Message-ID: <1372706605.2385.37.camel@dabdike>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
	 <20130701174423.GA10645@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:47374 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3GATX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 15:23:28 -0400
In-Reply-To: <20130701174423.GA10645@logfs.org>
Content-Language: en-US
Content-ID: <6473BCF54450CE409D98B1AD4F048D8E@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>

On Mon, 2013-07-01 at 13:44 -0400, J=F6rn Engel wrote:
> If a single device is bad, don't ever do a host
> reset.

This isn't a tenable position.  Sometimes a device looks bad because th=
e
host state for it has gone insane.  At that point, the only safe action
is a reset of the host to sane state.

I could be persuaded that you should never do the transport equivalent
of a bus reset (on non-SPI transports, at least), which is actually har=
d
to do on some of the modern transports, but I don't think you can get
away without having a host reset in the eh arsenal.

James

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
