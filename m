From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH v2 0/8] [SCSI] Enhanced sense and Unit Attention handling
Date: Thu, 11 Apr 2013 16:52:33 -0500
Message-ID: <516730A1.4090302@tributary.com>
References: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:27050 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3DKVwk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Apr 2013 17:52:40 -0400
In-Reply-To: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2/1/2013 11:53 AM, Ewan D. Milne wrote:
> The mechanism used is to flag when certain UA ASC/ASCQ codes are received 
> that report asynchronous changes to the storage device configuration. An
> appropriate uevent is then generated for the scsi_device or scsi_target 
> object.  An aggregation mechanism is used to avoid generating uevents at 
> too high a rate, and to coalesce multiple UAs reported by LUNs on the same
> target for a REPORTED LUNS DATA HAS CHANGED sense code.


	What happened to this patch? The trail of suggested fixes for the REPORT LUNS
DATA HAS CHANGED check condition is getting pretty long. The number of devices
(our product included) in the field that have the ability to on the fly modify
the luns on an I_T nexus is not decreasing.

	Is it because these patches are trying to fix more than one thing?

	What is the preferred way to fix this?

	Why not simply add a couple sdev_evt_send_simple()'s and an event coalesce
function to collapse this event when its received from multiple LUNs on the
I_T? A couple extra uevents isn't going to kill udev right? A really fancy
patch could attempt to clear the check conditions from LUNs that share the I_T.

	




