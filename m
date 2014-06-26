From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] [SCSI] aic94xx: Remove broken fallback for missing 'Ctrl-A' user settings
Date: Wed, 25 Jun 2014 22:44:53 -0400
Message-ID: <yq11tuccrtm.fsf@sermon.lab.mkp.net>
References: <1402267064.23860.42.camel@deadeye.wl.decadent.org.uk>
	<20140625111244.GB19415@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39458 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbaFZCph (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 22:45:37 -0400
In-Reply-To: <20140625111244.GB19415@infradead.org> (Christoph Hellwig's
	message of "Wed, 25 Jun 2014 13:12:44 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Sun, Jun 08, 2014 at 11:37:44PM +0100, Ben Hutchings wrote:
>> asd_process_ctrl_a_user() attempts to find user settings in flash,
>> and if they are missing it prepares a substitute structure containing
>> default values for PHY settings.  But having done so, it will still
>> try to read user settings - from some random address in flash, as the
>> local variable 'offs' has not been initialised.
>> 
>> Since asd_common_setup() already sets default PHY settings, there
>> seems to be no need to repeat them here, and we can just return 0.
>> 
>> Compile-tested only.

If I read this correctly we'll get the link rates initialized but the
sas_addr will no longer be populated for each phy_desc.

The old code copied the board global sas_addr into dflt_ps before
calling asd_process_ctrla_phy_settings(). Whereas asd_common_setup()
does not populate the sas_addr.

-- 
Martin K. Petersen	Oracle Linux Engineering
