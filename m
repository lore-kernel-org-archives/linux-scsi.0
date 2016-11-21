From: John Garry <john.garry@huawei.com>
Subject: Re: [RFC PATCH] scsi: libsas: fix WARN on device removal
Date: Mon, 21 Nov 2016 15:16:26 +0000
Message-ID: <7d4e4aa5-0d15-ca8c-243f-24c60e1378ed@huawei.com>
References: <1478185120-5509-1-git-send-email-john.garry@huawei.com>
 <be84afd4-640d-1913-404a-505fd72c1324@huawei.com>
 <b800ae5c-f275-728c-27b4-230663757781@huawei.com>
 <CAPcyv4g+XzCuHsUvqeE+r8hqgPK3yq=E9k23a89XcLs96bkphg@mail.gmail.com>
 <CAPcyv4hvuFLhS2sYXkccXMTSh-ggxo7uHN2Qt6i5g8GkyBksrw@mail.gmail.com>
 <9870e7bc-a472-1913-1930-ac022e8ad5e8@huawei.com>
 <58257D52.6090507@huawei.com>
 <93ae84f6-75a2-f576-808e-f98c6256b6a6@huawei.com>
 <58258631.1090203@huawei.com>
 <9bdd2ca5-aa72-6a18-b66d-8e791e4852c7@huawei.com>
 <CAPcyv4g7_kDAZNZ2ikBRgFsX-hFpcXEV2xg9YS0Ha7PjSBkzVQ@mail.gmail.com>
 <ca8ce351-ae6c-6878-4cd7-af7af11122ad@huawei.com>
 <CAPcyv4gO2oHg2FjVu89cmy7E7+9QPm4AVF_zSy04C3QXiM0UPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gO2oHg2FjVu89cmy7E7+9QPm4AVF_zSy04C3QXiM0UPw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, wangyijing <wangyijing@huawei.com>, linux-scsi <linux-scsi@vger.kernel.org>, John Garry <john.garry2@mail.dcu.ie>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linuxarm@huawei.com, lindar_liu@usish.com, Tejun Heo <tj@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-scsi@vger.kernel.org

>>>> @Maintainers, would you be willing to accept this patch as an interim fix
>>>> for the dastardly WARN while we try to fix the flutter issue?
>>>
>>>
>>> To me this adds a bug to quiet a benign, albeit noisy, warning.
>>>
>>
>> What is the bug which is being added?
>
> The bug where we queue a port teardown, but see a port formation event
> in the meantime.

As I understand, this vulnerability already exists:
http://marc.info/?l=linux-scsi&m=143801026028006&w=2

I actually don't understand how libsas dealt with flutter (which I take 
to mean a burst of up and down events) before these changes, as it can 
only queue simultaneously one up and one down event per port. So, if we 
get a flutter, then the events are lost and we get indeterminate state.

>
>> And it's a very noisy warning, as in 6K lines on the console when an
>> expander is unplugged.
>
> Does something like this modulate the failure?
>
> diff --git a/drivers/scsi/scsi_transport_sas.c
> b/drivers/scsi/scsi_transport_sas.c            index
> 60b651bfaa01..11401e5c88ba 100644
>                  --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -262,9 +262,10 @@ static void sas_bsg_remove(struct Scsi_Host
> *shost, struct sas_rphy *rphy
>  {
>         struct request_queue *q;
>
> -       if (rphy)
> +       if (rphy) {
>                 q = rphy->q;
> -       else
> +               rphy->q = NULL;
> +       } else
>                 q = to_sas_host_attrs(shost)->q;
>
>         if (!q)
>
> .
>
