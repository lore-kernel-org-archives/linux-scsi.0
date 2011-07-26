From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 02/12] bnx2fc: Introduce interface structure for each
 vlan interface
Date: Tue, 26 Jul 2011 13:41:42 +0400
Message-ID: <1311673302.17353.21.camel@mulgrave>
References: <1309242664-27252-1-git-send-email-bprakash@broadcom.com>
	 <1309242664-27252-3-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36859 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994Ab1GZJlv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 05:41:51 -0400
In-Reply-To: <1309242664-27252-3-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org

On Mon, 2011-06-27 at 23:30 -0700, Bhanu Prakash Gollapudi wrote:
> Currently, bnx2fc has a hba structure that can work with only a single vlan
> interface.  When there is a change in vlan id, it does not have the capability
> to switch to different vlan interface. To solve this problem, a new structure
> called 'interface' has been introduced, and each hba can now have multiple
> interfaces, one per vlan id.
> 
> Most of the patch is a moving the interface specific fields from hba to the
> interface structure, and appropriately modifying the dereferences. A list of
> interfaces (if_list) is maintained along with adapter list. During a create
> call, the interface structure is allocated and added to if_list and deleted &
> freed on a destroy call.  Link events are propogated to all interfaces
> belonging to the hba.

Best I can tell, the upstream prerequisites are satisfied, but I still
can't apply this because of a conflicting upstream patch:

commit 415199f2bd977fa4065d4e836b4b7543f7993bc3
Author: Michael Chan <mchan@broadcom.com>
Date:   Wed Jul 20 14:55:24 2011 +0000

    cnic: Add VLAN ID as a parameter during netevent upcall

Which actually introduces an explicit failure return for vlans.  Could
you respin from 2 on to sort this out?

Thanks,

James


