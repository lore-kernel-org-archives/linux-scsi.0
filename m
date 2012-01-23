From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 2/7] libsas: improve ata debug statements
Date: Mon, 23 Jan 2012 12:51:19 -0800
Message-ID: <CAA9_cmfHXr1GT-7OG_54NWccZHghwdK-xOPC5rjSj5L=swKTeQ@mail.gmail.com>
References: <20120121014910.24930.54011.stgit@localhost6.localdomain6>
	<20120121015049.24930.6244.stgit@localhost6.localdomain6>
	<FA947937481B428783C02E0BD63531CA@usish.com.cn>
	<4F1B1F69.5010000@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4F1B1F69.5010000@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 21, 2012 at 12:26 PM, Douglas Gilbert <dgilbert@interlog.co=
m> wrote:
> On 12-01-21 12:36 AM, Jack Wang wrote:
>>>
>>>
>>
>> [Jack Wang]
>> Nice improvement.
>> Thanks.
>>>
>>> It's difficult to determine which domain_device is triggering error
>>
>> recovery,
>>>
>>> so convert messages like:
>>>
>>> =A0 sas: ex 5001b4da000e703f phy08:T attached: 5001b4da000e7028
>>> =A0 sas: ex 5001b4da000e703f phy09:T attached: 5001b4da000e7029
>>> =A0 ...
>>> =A0 ata7: sas eh calling libata port error handler
>>> =A0 ata8: sas eh calling libata port error handler
>>>
>>> ...into:
>>>
>>> =A0 sas: ex 5001517e85cfefff phy05:T:9 attached: 5001517e85cfefe5 (=
stp)
>>> =A0 sas: ex 5001517e3b0af0bf phy11:T:8 attached: 5001517e3b0af0ab (=
stp)
>>> =A0 ...
>>> =A0 sas: ata7: end_device-21:1: dev error handler
>>> =A0 sas: ata8: end_device-20:0:5: dev error handler
>>>
>>> which shows attached link rate, device type, and associates a
>>> domain_device with its ata_port id to correlate messages emitted fr=
om
>>> libata-eh.
>
>
> A couple of comments. The "T" in the "phy08:T" stands for
> an expander phy's routing attribute being "table" I presume.

Yes.

> In smp_utils I'm thinking of changing that to "U" in the case
> where that expander (SAS-2 or later) supports table-to-table
> routing. The "U" indicates that phy can join other (sibling)
> expander phys to become an "enclosure universal port" which
> is nirvana for SAS expanders.

Ok, something like the following (please excuse mailer line wrapping):

diff --git a/drivers/scsi/libsas/sas_expander.c
b/drivers/scsi/libsas/sas_expander.c
index f8d941f..4b2ecd3 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -166,7 +166,22 @@ static inline void *alloc_smp_resp(int size)
        return kzalloc(size, GFP_KERNEL);
 }

-/* ---------- Expander configuration ---------- */
+static char sas_route_char(struct domain_device *dev, struct ex_phy *p=
hy)
+{
+       switch (phy->routing_attr) {
+       case TABLE_ROUTING:
+               if (dev->ex_dev.t2t_supp)
+                       return 'U';
+               else
+                       return 'T';
+       case DIRECT_ROUTING:
+               return 'D';
+       case SUBTRACTIVE_ROUTING:
+               return 'S';
+       default:
+               return '?';
+       }
+}

 static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
                           void *disc_resp)
@@ -257,10 +272,8 @@ static void sas_set_ex_phy(struct domain_device
*dev, int phy_id,

        SAS_DPRINTK("ex %016llx phy%02d:%c:%X attached: %016llx (%s)\n"=
,
                    SAS_ADDR(dev->sas_addr), phy->phy_id,
-                   phy->routing_attr =3D=3D TABLE_ROUTING ? 'T' :
-                   phy->routing_attr =3D=3D DIRECT_ROUTING ? 'D' :
-                   phy->routing_attr =3D=3D SUBTRACTIVE_ROUTING ? 'S' =
: '?',
-                   phy->linkrate, SAS_ADDR(phy->attached_sas_addr), ty=
pe);
+                   sas_route_char(dev, phy), phy->linkrate,
+                   SAS_ADDR(phy->attached_sas_addr), type);
 }


=2E..can also fix up the same in sas_print_parent_topology_bug

>
> enum sas_dev_type::EDGE_DEV seems a pretty bad name and
> should be changed to EXPANDER_DEV as that is more
> accurate. Where fanout expanders ever made in SAS-1?
> Not many I would expect. In SAS-2++ (SPL, SPL-2) the
> "edge" and "fanout" distinction has been dropped and
> the numerical value for fanout expanders (3) has been
> marked as obsolete.

Ok, that's a cleanup for another patch, but I'll go ahead and
formalize the above routing char fixup and repost the patch as
"libsas: improve debug statements" rather than "libsas: improve ata
debug statements"

--
Dan
