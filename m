From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: Is there a grand plan for FC failover?
Date: 29 Jan 2004 13:31:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075401081.2426.98.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF2802C013BE@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:29902 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266319AbUA2Sbd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 13:31:33 -0500
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C013BE@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: "Philip R. Auld" <pauld@egenera.com>, 'Patrick Mansfield' <patmans@us.ibm.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

On Thu, 2004-01-29 at 12:35, Smart, James wrote:
> Why do you imply that you're down to a single path ? With multiple port
> devices, and the T10 unclarity on multiport support, simple reservations
> didn't bring you down to the single port access you are describing. Some
> devices may have implemented it this way, but the standard didn't say they
> had to or even that they should.

T10 implies SCSI-2 reservations protect single paths.  Any multi-port
SCSI-2 reservation implementations tend to be vendor specific.  That's a
nasty I don't think we want to get into.

> And this picture changes significantly with the use of Persistent
> Reservations and the use of keys.

That's the point, it doesn't.  T10 clarified the persistent reservation
holder (5.6.2.6 in rev 16) so that it's a specific I_T nexus (which is
effectively a specific path unless you have fabric redundancy) except
for all registrant reservations (which aren't useful for clustering).

Obviously, this seems to require that the reservation be held against
everyone when the port switches, which would preclude doing user level
reservation handling, hence the need for a separate ownership API
(assuming all vendors get on the same page about this).

James


