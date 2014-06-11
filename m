From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 3/3] TARGET/sbc,loopback: Adjust command data length in case pi exists on the wire
Date: Wed, 11 Jun 2014 19:20:20 -0400
Message-ID: <yq1bntzrq2z.fsf@sermon.lab.mkp.net>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
	<1402223228-23768-4-git-send-email-sagig@mellanox.com>
	<1402387450.5774.56.camel@haakon3.risingtidesystems.com>
	<504EB66DAC8D234EB8E8560985C2D7AD46D1D00E@avmb2.qlogic.org>
	<53980434.1000306@dev.mellanox.co.il>
	<1402522215.17740.29.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402522215.17740.29.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
	(Nicholas A. Bellinger's message of "Wed, 11 Jun 2014 14:30:15 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Quinn Tran <quinn.tran-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "michaelc@cs.wisc.edu" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "martin.petersen@oracle.com" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "roland@kernel.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel@vger.kernel.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> writes:

nab> Hard to say.  Discarding the transport length in v2 doesn't seem
nab> like a good idea, but subtracting from cmd->prot_length in v1 is
nab> using the sector count from the CDB anyways, so it's essentially
nab> the same tradeoff of recalculating the transport's cmd->data_length
nab> from values within the CDB w/ prot=1.

nab> MKP, WDYT..?

My general feeling is that once sbc on the target sees {rd,wr}protect >
0 we're in the territory where you should start separating data and
PI internally.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
