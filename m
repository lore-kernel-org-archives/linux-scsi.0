From: richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in pmcraid_chr_ioctl()
Date: Tue, 25 Oct 2011 00:50:08 +0200
Message-ID: <CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
	<1319496149.2094.3.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319496149.2094.3.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, davej@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 25, 2011 at 12:42 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2011-10-25 at 00:38 +0200, Jesper Juhl wrote:
>> The first argument to kmalloc() is the size, the second is
>> flags. pmcraid_chr_ioctl() gets this wrong and swaps the
>> arguments. This patch corrects the mistake.
>>
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>> ---
>> =A0drivers/scsi/pmcraid.c | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> =A0compile tested only.
>>
>> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
>> index d079f9a..da19bdf 100644
>> --- a/drivers/scsi/pmcraid.c
>> +++ b/drivers/scsi/pmcraid.c
>> @@ -4103,7 +4103,7 @@ static long pmcraid_chr_ioctl(
>> =A0 =A0 =A0 struct pmcraid_ioctl_header *hdr =3D NULL;
>> =A0 =A0 =A0 int retval =3D -ENOTTY;
>>
>> - =A0 =A0 hdr =3D kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_he=
ader));
>> + =A0 =A0 hdr =3D kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_K=
ERNEL);
>>
>> =A0 =A0 =A0 if (!hdr) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pmcraid_err("faile to allocate memory fo=
r ioctl header\n");
>> --
>> 1.7.7
>>
>>
>
> James seems to be uninterested in picking up
> obvious and trivially correct patches.
>

BTW: What about a checkpatch.pl rule to detect such a misuse of kmalloc=
()?
We could grep for "k[mzc]alloc(GFP_".

--=20
Thanks,
//richard
