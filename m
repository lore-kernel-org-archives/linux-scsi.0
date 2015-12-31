From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/20] scsi_dh_alua: update all port states
Date: Thu, 31 Dec 2015 15:09:30 +0100
Message-ID: <5685371A.6080703@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
 <1449560260-53407-15-git-send-email-hare@suse.de>
 <20151230132354.GD15270@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbbLaOJc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Dec 2015 09:09:32 -0500
In-Reply-To: <20151230132354.GD15270@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 12/30/2015 02:23 PM, Christoph Hellwig wrote:
> On Tue, Dec 08, 2015 at 08:37:34AM +0100, Hannes Reinecke wrote:
>> When we read in the target port group state we should be
>> updating all affected port groups, otherwise we risk
>> running out of sync.
>
> Why would we ever have multiple alua_port_group structures for the
> same port that we'd need to iterate here?
>
That is the whole point :-)
The index into the port_group structure is the tuple
(LUN ID, group ID), where each tuple corresponds to a different/separat=
e=20
port group state.
So for each LUN ID we will have at least two port_group structures, the=
=20
states of which will be returned per call to REPORT TARGET PORT GROUPS.
And as the other paths might be unavailable we might not be able to=20
execute REPORT TARGET PORT GROUPS at all. So we need to update it here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
