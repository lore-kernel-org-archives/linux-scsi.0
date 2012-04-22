From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [isci PATCH v3 1/4] libata: export ata_port suspend/resume
 infrastructure for sas
Date: Sat, 21 Apr 2012 18:06:57 -0700
Message-ID: <CABE8wwu-E0qAf1EyH=wToG6nguvph6OEJbAqv3S1nCrty9pLwA@mail.gmail.com>
References: <20120314071312.7223.10946.stgit@dwillia2-linux.jf.intel.com>
	<20120314071353.7223.5361.stgit@dwillia2-linux.jf.intel.com>
	<4F9252FC.9020706@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4F9252FC.9020706@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 20, 2012 at 11:26 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 03/14/2012 03:13 AM, Dan Williams wrote:
>>
>> Reuse ata_port_{suspend|resume}_common for sas. =A0This path is chos=
en
>> over adding coordination between ata-tranport and sas-transport beca=
use
>> libsas wants to revalidate the domain at resume-time at the host lev=
el.
>> It can not validate links have resumed properly until libata has had=
 a
>> chance to perform its revalidation, and any sane placing of an ata_p=
ort
>> in the sas-transport model would delay it's resumption until after t=
he
>> host.
>>
>> Export the common portion of port suspend/resume (bypass pm_runtime)=
,
>> and allow sas to perform these operations asynchronously (similar to=
 the
>> libsas async-ata probe implmentation). =A0Async operation is determi=
ned by
>> having an external, rather than stack based, location for storing th=
e
>> result of the operation.
>>
>> Reviewed-by: Jacek Danecki<jacek.danecki@intel.com>
>> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
>> ---
>> =A0drivers/ata/libata-core.c | =A0 58
>> ++++++++++++++++++++++++++++++++++++---------
>> =A0include/linux/libata.h =A0 =A0| =A0 11 +++++++++
>> =A02 files changed, 57 insertions(+), 12 deletions(-)
>
>
> Now that libata's runtime PM problems seem to be fixed for the moment=
, we
> can revisit port PM here. =A0Just checking... =A0Is this patch still =
needed?

Yeah, this one is still needed.  libsas wants to validate links at the
host level.  I tried letting these routines be called "naturally" by
registering libsas-ata_ports with the ata-transport class, but it
hangs / got messy in cases where the link needed recovery
(SATA_PENDING), but the ata_port was still suspended.  Also, I think
the ata_port pm_runtime bits need a review for suitability for the
libsas case.

So, with this approach libsas does not register libsas-ata_ports with
the ata transport class and instead calls the core routines directly
(similar to how libata did before the dev_pm_ops rework).

--
Dan
