Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BDFF0;
	Sun, 26 Nov 2023 04:01:17 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A98EA21C1F;
	Sun, 26 Nov 2023 12:01:15 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6386B13488;
	Sun, 26 Nov 2023 12:01:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EBXFFoszY2XiGQAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 26 Nov 2023 12:01:15 +0000
Message-ID: <00eb0928-5691-4e85-a923-de9c4934856c@suse.de>
Date: Sun, 26 Nov 2023 13:01:14 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible Bug? LIO does not support SCSI commands with Immediate
 Bit Set?
Content-Language: en-US
To: Lee Duncan <lduncan@suse.com>, target-devel <target-devel@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi <linux-scsi@vger.kernel.org>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>
References: <31851279-0884-48ba-8c4b-7d6147e59508@suse.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <31851279-0884-48ba-8c4b-7d6147e59508@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++++++++
X-Spam-Score: 11.30
X-Rspamd-Server: rspamd1
X-Rspamd-Queue-Id: A98EA21C1F
Authentication-Results: smtp-out1.suse.de;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=suse.de (policy=none);
	spf=softfail (smtp-out1.suse.de: 2a07:de40:b281:104:10:150:64:97 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Spamd-Result: default: False [11.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RCVD_COUNT_THREE(0.00)[3];
	 TO_DN_ALL(0.00)[];
	 MX_GOOD(-0.01)[];
	 BAYES_HAM(-3.00)[100.00%];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 SUBJECT_ENDS_QUESTION(1.00)[];
	 RCVD_TLS_ALL(0.00)[];
	 DMARC_POLICY_SOFTFAIL(0.10)[suse.de : No valid SPF, No valid DKIM,none]

On 11/25/23 19:28, Lee Duncan wrote:
> Hi Martin/list:
> 
> I am trying to track down an issue I am seeing when trying to boot using 
> iSCSI root using the fastlinq qedi converged network adapter initiator 
> and an LIO target.
> 
> In this configuration, but using a non-LIO (hardware) iSCSI target, 
> everything "just works". But when I switch to using an LIO software 
> target, I get this error when booting:
> 
>> 2023-09-20T14:10:32.835358-0500 worker5 kernel: Illegally set 
>> Immediate Bit in iSCSI Initiator Scsi Command PDU.
>> ... > 2023-09-20T14:10:32.835422-0500 worker5 kernel: Got unknown iSCSI 
> OpCode: 0x52
> 
> It looks like the fastlinq adapter is sending a SCSI write (0x12) with 
> the Immediate bit set (0x40).
> 
> The code in iscsi_target.c:iscsit_setup_scsi_cmd(): looks like this:
> 
>>     if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
>>         pr_err("Illegally set Immediate Bit in iSCSI Initiator"
>>                 " Scsi Command PDU.\n");
>>         return iscsit_add_reject_cmd(cmd,
>>                          ISCSI_REASON_BOOKMARK_INVALID, buf);
>>     }
>>
> 
> But I looked at rfc3720, and it looks like SCSI PDUs can have the 
> Immediate Bit set:
> 
>> 10.3.  SCSI Command
>>    The format of the SCSI Command PDU is:
>>    Byte/     0       |       1       |       2       |       3       |
>>       /              |               |               |               |
>>      |0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|
>>      +---------------+---------------+---------------+---------------+
>>     0|.|I| 0x01      |F|R|W|. .|ATTR | Reserved                      |
>>      +---------------+---------------+---------------+---------------+
>>     4|TotalAHSLength | DataSegmentLength                             |
>>      +---------------+---------------+---------------+---------------+
>>     8| Logical Unit Number (LUN)                                     |
>>      +                                                               +
>>    12|                                                               |
>>      +---------------+---------------+---------------+---------------+
>> ...
> 
> Where "I" is the immediate bit.
> 
> Frankly, I'm never sure I read the SPEC correctly, so I'm not sure if 
> I'm mistaken here, but it looks like LIO does not allow the Immediate 
> bit (and hence Immediate data), even though the SPEC does allow it. But 
> it also looks like, during negotiation phase, LIO negotiates 
> ImmediateData like any other parameter, allowing "YES".
> 
> In our testing, if we set ImmediateData=No in the target, then our 
> problem goes away, i.e. we can now boot from an LIO target. This is 
> because Immediate Data is negotiated off, of course.
> 
> Is this a bug, or is this adapter doing something wrong? I would 
> appreciate other viewpoints.
> 
> Thank you.

Sounds like a bug.
Can you check if this helps?

diff --git a/drivers/target/iscsi/iscsi_target.c 
b/drivers/target/iscsi/iscsi_target.c
index b516c2893420..ad68706ad9f7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1060,7 +1060,8 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn 
*conn, struct iscsit_cmd *cmd,
 
ISCSI_REASON_BOOKMARK_INVALID, buf);
         }

-       if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
+       if ((hdr->opcode & ISCSI_OP_IMMEDIATE) &&
+           !conn->sess->sess_ops->ImmediateData) {
                 pr_err("Illegally set Immediate Bit in iSCSI Initiator"
                                 " Scsi Command PDU.\n");
                 return iscsit_add_reject_cmd(cmd,

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

