From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH V2] scsi: mpt3sas: remove redundant wmb
Date: Fri, 21 Apr 2017 13:26:29 +0530
Message-ID: <CAK=zhgpmcmq-CnWuU9=WRJpAaEduw63LSPLE9yZzF_sUHkM4AA@mail.gmail.com>
References: <1491591978-17880-1-git-send-email-okaya@codeaurora.org>
 <yq1y3uvq0c1.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <yq1y3uvq0c1.fsf@oracle.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Chaitra P B <chaitra.basappa@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, timur@codeaurora.org, Sathya Prakash <sathya.prakash@broadcom.com>, open list <linux-kernel@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <MPT-FusionLinux.pdl@broadcom.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 20, 2017 at 7:58 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> Sinan Kaya <okaya@codeaurora.org> writes:
>
>> Due to relaxed ordering requirements on multiple architectures,
>> drivers are required to use wmb/rmb/mb combinations when they need to
>> guarantee observability between the memory and the HW.
>>
>> The mpt3sas driver is already using wmb() for this purpose.  However,
>> it issues a writel following wmb(). writel() function on arm/arm64
>> arhictectures have an embedded wmb() call inside.

[Sreekanth] Whether same thing applicable for SPARC & POWER
architectures. If yes then we are fine with this patch changes.

>>
>> This results in unnecessary performance loss and code duplication.
>>
>> writel already guarantees ordering for both cpu and bus. we don't need
>> additional wmb()
>
> Broadcom folks, please review!
>
> --
> Martin K. Petersen      Oracle Linux Engineering
