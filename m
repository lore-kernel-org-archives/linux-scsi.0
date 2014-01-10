From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: iSCSI request keep rejected by microsoft iSCSI target because
 of write_same check
Date: Fri, 10 Jan 2014 14:24:09 -0600
Message-ID: <52D056E9.8080008@cs.wisc.edu>
References: <52CE77FB.8020100@oracle.com> <52CEEC97.8050108@cs.wisc.edu> <52CF8F0C.3040304@oracle.com> <52CFA440.7030104@cs.wisc.edu> <52CFAA9F.5010706@oracle.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncBCZ4TFNN2YMRB4FNYGLAKGQET3NZTDY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <52CFAA9F.5010706-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: vaughan <vaughan.cao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 01/10/2014 02:09 AM, vaughan wrote:
> On 01/10/2014 03:41 PM, Mike Christie wrote:
>> On 1/10/14 12:11 AM, vaughan wrote:
>>> I haven't figure out why it's rejected with "bookmark invalid"(9)
>>> reason, rather than "command not supported". IMO "bookmark invalid" is
>>> used when minor protocol conflict such as final flag not set with
>>> non-write command. However, I haven't find error of this kind in
>>> report_opcode, so I guess it's not supported on the target.
>>>
>>
>> Is it possible to get a wireshark/tcpdump trace? It does not have to
>> be during boot. We just need to see what commands are sent and the
>> response the target is returning.
>>
>> I forgot we know some microsoft iscsi target people. We can just email
>> them with the trace to confirm what is going on with the target. The
>> trace seems to be easier for them than them interpreting linux kernel
>> logs.
> I enabled debug_iscsi_tcp, here is a more detailed log in normal connection.
> Does "conn error (1020)" mean it's target peer who disconnect the
> connection at the same time of reject report_opcode?

Yes.

> If it is, I think iSCSI boot failure can't be avoided without disable
> write_same check on OEL.

Yes, you are right. Due to how more distros do boot, iscsid will not be
up and you will hang. If are talking about disablement though I think it
should not be done at the iscsi layer. It should be some sort of
white/black list at the scsi device layer or something like that.

However, I will ping Microsoft and cc you and we can see what is up for
sure. Maybe we will get lucky and they will have a release with a fix on
their side.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/groups/opt_out.
