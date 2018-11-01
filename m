From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Thu, 1 Nov 2018 03:39:54 +0200
Message-ID: <1c58c82f-5cfa-f483-097a-5b82904e5e9a@electrozaur.com>
References: <20180930205448.26205-1-natechancellor@gmail.com>
 <10b12992-3570-4646-374b-82cbd7276839@acm.org>
 <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
 <1538503063.193396.6.camel@acm.org>
 <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
 <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181025213144.GB24709@flashbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Bart Van Assche <bvanassche@acm.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 26/10/18 00:31, Nathan Chancellor wrote:
> On Tue, Oct 02, 2018 at 04:06:31PM -0700, Bart Van Assche wrote:
<>
> 
> Hi Bart,
> 
> I'm sorry if I didn't follow the conclusion of this conversation properly
> but this is the below diff you were initially looking for, correct?
> 
> If so, Boaz and Nick, do you have any objections if this is v2? I'd like
> to get this patch accepted so the warning can be fixed for everyone.
> 

ACK on both the original and below code they will all work just fine.

I do like the original "just remove the _weak thingy". But this one
will work as well.

The "with extern" version suggested before is more cumbersome because it will
need an EXPORT_SYMBOL() but will also work.

The all use of osd_root_object is just. A properly C-types pointer to couple
of ZEROS. but since the Interface needs a pointer, those zeros need storage
somewhere. It does not matter where. (The value of the pointer is not used
only its content)

Do you need that I send a proper patch? Actually the original first patch
is the version I like. (And again all 3 approaches will work)

Thanks
Boaz

> Thanks,
> Nathan
> 
> ================================================================================
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index e19fa883376f..4250f739beb3 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -58,6 +58,8 @@
> 
>  enum { OSD_REQ_RETRIES = 1 };
> 
> +static const struct osd_obj_id osd_root_object;
> +
>  MODULE_AUTHOR("Boaz Harrosh <ooo@electrozaur.com>");
>  MODULE_DESCRIPTION("open-osd initiator library libosd.ko");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index eaf36ccf58db..770c758baaa9 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
> @@ -73,6 +73,7 @@
> 
>  static const char osd_name[] = "osd";
>  static const char *osd_version_string = "open-osd 0.2.1";
> +static const struct osd_obj_id osd_root_object;
> 
>  MODULE_AUTHOR("Boaz Harrosh <ooo@electrozaur.com>");
>  MODULE_DESCRIPTION("open-osd Upper-Layer-Driver osd.ko");
> diff --git a/include/scsi/osd_types.h b/include/scsi/osd_types.h
> index 48e8a165e136..eb31357ec8b3 100644
> --- a/include/scsi/osd_types.h
> +++ b/include/scsi/osd_types.h
> @@ -28,8 +28,6 @@ struct osd_obj_id {
>         osd_id id;
>  };
> 
> -static const struct __weak osd_obj_id osd_root_object = {0, 0};
> -
>  struct osd_attr {
>         u32 attr_page;
>         u32 attr_id;
> 
