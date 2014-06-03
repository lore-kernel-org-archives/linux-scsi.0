From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] libiscsi, iser: Adjust data_length to include protection information
Date: Tue, 03 Jun 2014 18:18:58 -0400
Message-ID: <yq1wqcx3act.fsf@sermon.lab.mkp.net>
References: <1401639581-20111-1-git-send-email-sagig@mellanox.com>
	<1401639581-20111-2-git-send-email-sagig@mellanox.com>
	<538DF27F.50903@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <538DF27F.50903-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org> (Mike Christie's message of "Tue, 03
	Jun 2014 11:06:23 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org> writes:

Mike> On 06/01/2014 11:19 AM, Sagi Grimberg wrote:
>> 
>> +/*
>> + * data integrity helpers
>> + */
>> +static inline unsigned +iscsi_prot_len(unsigned data_len, unsigned
>> sector_size) +{
>> + switch (sector_size) {
>> + case 512:
>> + return (data_len >> 9) * 8;
>> + case 1024:
>> + return (data_len >> 10) * 8;
>> + case 2048:
>> + return (data_len >> 11) * 8;
>> + case 4096:
>> + return (data_len >> 12) * 8;
>> + default:
>> + return (data_len >> ilog2(sector_size)) * 8;
>> + }
>> +}
>> #endif

Mike> I do not think this should not be in the iscsi code.

In the data integrity update I posted there's a flag saying "transfer PI
on the wire". That was meant to be the thing driver's should key off of
to adjust transfer length. But I'm also happy to provide a unsigned int
scsi_transfer_length(struct scsi_cmnd *) thingy that returns the right
byte count. Just bear in mind that the host-facing DIX transfer length
may be different.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
