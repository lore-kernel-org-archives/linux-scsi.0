From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] libiscsi, iser: Adjust data_length to include protection information
Date: Wed, 06 Aug 2014 11:54:32 -0400
Message-ID: <yq11tstd35z.fsf@sermon.lab.mkp.net>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
	<1402477799-24610-3-git-send-email-sagig@mellanox.com>
	<53D4CFAB.3040804@gmail.com> <53E22300.3090907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53E22300.3090907-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> (Sagi Grimberg's message of
	"Wed, 06 Aug 2014 15:43:44 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Boaz Harrosh <openosd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> writes:

>> BTW: When reading DIFF devices, don't you have extra bits to read as
>> well?  How does the DIFF read works? Please get me up to speed. I'm
>> not familiar with this protocol?  (I'd imagine that if say an app
>> reads X bytes with DIFF info, it wants to receive its DIFF checksome
>> for every sector in X, where is this info on the iscsi wire?)
>> 

Sagi> The application wants to read X bytes from a DIF formatted device,
Sagi> the initiator will prepare buffers for data and for DIF data (in
Sagi> some implementations it can be the same buffer but not in Linux),
Sagi> and request reading X+DIF_size bytes (where each block is followed
Sagi> by it's corresponding integrity field) and place the data blocks
Sagi> in the data buffer and the integrity fields in the DIF data buffer
Sagi> (usually this is offloaded).

READ CAPACITY returns a block size of 512 even though the blocks on disk
are 520. That's the beauty of it.

At the command level all transfers are expressed in number of blocks,
not bytes. The application will see an N x 512 byte buffer but on the
wire between initiator and target we'll transfer N x 520 bytes.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
