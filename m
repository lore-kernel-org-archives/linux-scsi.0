From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2 02/16] scsi: don't use
 fc_bsg_job::request and fc_bsg_job::reply directly
Date: Fri, 28 Oct 2016 13:31:12 +0200
Message-ID: <d9a73963-1ade-2b6f-77bd-044e19675fd8@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <b92d12e4f78c4998bc8ad000359c127e673379f3.1476276823.git.jthumshirn@suse.de>
 <2ea07f3f-88eb-b795-fa37-a223bf80e581@linux.vnet.ibm.com>
 <20161013162405.aoxy3bdkc4bqtwsk@linux-x5ow.site>
 <4b411836-e76f-b67a-3d49-ad3d51b8f216@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <4b411836-e76f-b67a-3d49-ad3d51b8f216-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "open list:S390 ZFCP DRIVER" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dick Kennedy <dick.kennedy-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "open list:FCOE SUBSYSTEM (libfc, libfcoe, fcoe)" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Ulrich Weigand <Ulrich.Weigand-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Richard Biener <rguenther-l3A5Bk7waGM@public.gmane.org>, Sudarsana Kalluru <sudarsana.kalluru-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anil Gurumurthy <anil.gurumurthy-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel@vger>
List-Id: linux-scsi@vger.kernel.org

On 10/28/2016 11:53 AM, Steffen Maier wrote:
> =

> =

> On 10/13/2016 06:24 PM, Johannes Thumshirn wrote:
>> On Thu, Oct 13, 2016 at 05:15:25PM +0200, Steffen Maier wrote:
>>> I'm puzzled.
>>>
>>> $ git bisect start fc_bsg master
> =

>>>> 3087864ce3d7282f59021245d8a5f83ef1caef18 is the first bad commit
>>>> commit 3087864ce3d7282f59021245d8a5f83ef1caef18
>>>> Author: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
>>>> Date:   Wed Oct 12 15:06:28 2016 +0200
>>>>
>>>>     scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly
>>>>
>>>>     Don't use fc_bsg_job::request and fc_bsg_job::reply directly,
>>>> but use
>>>>     helper variables bsg_request and bsg_reply. This will be
>>>> helpfull  when
>>>>     transitioning to bsg-lib.
>>>>
>>>>     Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
>>>>
>>>> :040000 040000 140c4b6829d5cfaec4079716e0795f63f8bc3bd2
>>>> 0d9fe225615679550be91fbd9f84c09ab1e280fc M    drivers
>>>
>>> From there (on the reverse bisect path) I get the following Oops,
>>> except for the full patch set having another stack trace as in my
>>> previous
>>> mail (dying in zfcp code).
>>>
>>
>> [...]
>>
>>>
>>>> @@ -3937,6 +3944,7 @@ fc_bsg_request_handler(struct request_queue
>>>> *q, struct Scsi_Host *shost,
>>>>      struct request *req;
>>>>      struct fc_bsg_job *job;
>>>>      enum fc_dispatch_result ret;
>>>> +    struct fc_bsg_reply *bsg_reply;
>>>>
>>>>      if (!get_device(dev))
>>>>          return;
>>>> @@ -3973,8 +3981,9 @@ fc_bsg_request_handler(struct request_queue
>>>> *q, struct Scsi_Host *shost,
>>>>          /* check if we have the msgcode value at least */
>>>>          if (job->request_len < sizeof(uint32_t)) {
>>>>              BUG_ON(job->reply_len < sizeof(uint32_t));
>>>> -            job->reply->reply_payload_rcv_len =3D 0;
>>>> -            job->reply->result =3D -ENOMSG;
>>>> +            bsg_reply =3D job->reply;
>>>> +            bsg_reply->reply_payload_rcv_len =3D 0;
>>>> +            bsg_reply->result =3D -ENOMSG;
> =

> Compiler optimization re-ordered above two lines and the first pointer
> derefence is bsg_reply->result [field offset 0] where bsg_reply is NULL.
> The assignment tries to write to memory at address NULL causing the
> kernel page fault.
> =

I spoke to our compiler people, and they strongly believed this not to
be the case. Or, put it the other way round, if such a thing would
happen it would be a compiler issue.

Have you checked the compiler output?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare-l3A5Bk7waGM@public.gmane.org			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
