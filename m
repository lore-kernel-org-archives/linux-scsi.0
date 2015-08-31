From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH] lpfc: Fix possible use-after-free and double free in
 lpfc_mbx_cmpl_rdp_page_a2()
Date: Mon, 31 Aug 2015 16:53:37 -0400
Message-ID: <55E4BED1.7050201@avagotech.com>
References: <1439809382-32419-1-git-send-email-jthumshirn@suse.de>
 <20150817232634.00006d80@localhost> <mqdfv3h5cia.fsf@c203.arch.suse.de>
 <20150819002751.00000f06@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150819002751.00000f06@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dick Kennedy <dick.kennedy@avagotech.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Colin King <colin.king@canonical.com>
List-Id: linux-scsi@vger.kernel.org

On 8/18/2015 6:27 PM, Sebastian Herbszt wrote:
> Johannes Thumshirn wrote:
>> Sebastian Herbszt <herbszt@gmx.de> writes:
>>
>>> Johannes Thumshirn wrote:
>>>> If the bf_get() call in lpfc_mbx_cmpl_rdp_page_a2() does succeeds, execution
>>>> continues normally and mp gets kfree()d.
>>>>
>>>> If the subsequent call to lpfc_sli_issue_mbox() fails execution jumps to the
>>>> error label where lpfc_mbuf_free() is called with mp->virt and mp->phys as
>>>> function arguments. This is the use after free. Following the use after free mp
>>>> gets kfree()d again which is a double free.
>>> A similar patch was posted by Colin Ian King on 2015-07-31 [1].
>>>
>>> [1] http://marc.info/?l=linux-scsi&m=143835937206204&w=2
>> OK,
>>
>> Is it already in James' tree (haven't checked)? The problematic code was
>> merged for 4.2-rc1 so if the fix (Collin's or mine I don't care) could go
>> in while we're still in the rc phase, we could avoid all that stable
>> circus.
>>
>> Thanks for digging this out.
>>
>> Byte,
>>          Johannes
> It is not yet in scsi.git.
>
> James S., Dick, which patch do you prefer?
>
> Sebastian

I looked at both and liked Johannes patch better.

-- james s
