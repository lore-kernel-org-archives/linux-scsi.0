From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] scsi: qla4xxx: Don't call dma_free_coherent when buf
 is NULL
Date: Fri, 22 Mar 2019 15:25:05 +0100
Message-ID: <CAK8P3a27E7w804RcNNX1OOfgqwkbcxf42XiyUORFaG_wkSUXqw@mail.gmail.com>
References: <20190307184125.21419-1-natechancellor@gmail.com>
 <20190307231534.2640-1-natechancellor@gmail.com> <CAKwvOdmFnnGOnbQ-0fAeOpAMDjnYnN1mkiNjbcW8uNss9cSrVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOdmFnnGOnbQ-0fAeOpAMDjnYnN1mkiNjbcW8uNss9cSrVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>, QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 8, 2019 at 10:17 PM 'Nick Desaulniers' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
>
> On Thu, Mar 7, 2019 at 3:17 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > When building with -Wsometimes-uninitialized, Clang warns:
> >
> > drivers/scsi/qla4xxx/ql4_os.c:5915:7: warning: variable 'buf_dma' is
> > used uninitialized whenever 'if' condition is false
> > [-Wsometimes-uninitialized]
> >
> > Don't call dma_free_coherent when buf is NULL, meaning that we never
> > called dma_alloc_coherent and initialized buf_dma.
> >
> > Fixes: 2a991c215978 ("[SCSI] qla4xxx: Boot from SAN support for open-iscsi")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/391
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

> > diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> > index 16a18d5d856f..9f56dafc3cda 100644
> > --- a/drivers/scsi/qla4xxx/ql4_os.c
> > +++ b/drivers/scsi/qla4xxx/ql4_os.c
> > @@ -5982,7 +5982,8 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
> >                           ddb_index[1]));
> >
> >  exit_boot_info_free:
> > -       dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);
> > +       if (buf)
> > +               dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);
>
> Same thoughts as: https://lkml.org/lkml/2019/3/8/786
> WDYT?

Initializing the variable is definitely worse here, don't listen to
clang's bad suggestions ;-)

This was my fix, I'll send that as a proper patch as well:

--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5928,7 +5928,7 @@ static int get_fw_boot_info(struct scsi_qla_host
*ha, uint16_t ddb_index[])
                val = rd_nvram_byte(ha, sec_addr);
                if (val & BIT_7)
                        ddb_index[1] = (val & 0x7f);
-
+               goto exit_boot_info;
        } else if (is_qla80XX(ha)) {
                buf = dma_alloc_coherent(&ha->pdev->dev, size,
                                         &buf_dma, GFP_KERNEL);


      Arnd
