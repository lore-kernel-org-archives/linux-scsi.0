From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] lpfc: Fix possible use-after-free and double free in lpfc_mbx_cmpl_rdp_page_a2()
Date: Tue, 18 Aug 2015 08:36:29 +0200
Message-ID: <mqdfv3h5cia.fsf@c203.arch.suse.de>
References: <1439809382-32419-1-git-send-email-jthumshirn@suse.de>
	<20150817232634.00006d80@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150817232634.00006d80@localhost> (Sebastian Herbszt's message
	of "Mon, 17 Aug 2015 23:26:34 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Colin King <colin.king@canonical.com>
List-Id: linux-scsi@vger.kernel.org

Sebastian Herbszt <herbszt@gmx.de> writes:

> Johannes Thumshirn wrote:
>> If the bf_get() call in lpfc_mbx_cmpl_rdp_page_a2() does succeeds, execution
>> continues normally and mp gets kfree()d.
>> 
>> If the subsequent call to lpfc_sli_issue_mbox() fails execution jumps to the
>> error label where lpfc_mbuf_free() is called with mp->virt and mp->phys as
>> function arguments. This is the use after free. Following the use after free mp
>> gets kfree()d again which is a double free.
>
> A similar patch was posted by Colin Ian King on 2015-07-31 [1].
>
> [1] http://marc.info/?l=linux-scsi&m=143835937206204&w=2

OK,

Is it already in James' tree (haven't checked)? The problematic code was
merged for 4.2-rc1 so if the fix (Collin's or mine I don't care) could go
in while we're still in the rc phase, we could avoid all that stable
circus.

Thanks for digging this out.

Byte,
        Johannes
