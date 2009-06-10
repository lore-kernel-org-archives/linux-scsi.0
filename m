From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: do Symmetrix multipath-tools defaults need update
	? or scsi-to-blk errors management ?
Date: Wed, 10 Jun 2009 18:34:52 -0500
Message-ID: <4A30431C.3030809@cs.wisc.edu>
References: <1766094670.1725191244670599365.JavaMail.root@zimbra16-e3.priv.proxad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060906060402030408040204"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1766094670.1725191244670599365.JavaMail.root@zimbra16-e3.priv.proxad.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Levy_Jerome@emc.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060906060402030408040204
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/10/2009 04:49 PM, christophe.varoqui@free.fr wrote:
> Hi Jerome,
>
> EMC recently asked my/one-of-your client to active "queue_if_no_path" on Symmetrix logical units, which is not the current default setting in the upstream multipath-tools package.
>
> I'd like to know if you intent on submitting a patch to change the default setting accordingly, or if you'd rather let the no-queueing default unchanged and work on fixing the root cause of this issue.
>
> ::: Background information, root cause :::
>
> The Symmetrix array proved to return scsi errors io to submitters in certains circumstances (I was told of errors on R1+R2 network link). The linux kernel lacking finesse in the SCSI->DM error reporting ends-up invalidating in turn each path of the multipath before the multipathd daemon gets a chance to revalidate. "queue_if_no_path" being disabled, the io errors ends up in the FS layer and in the userspace submitter.
>
> ::: error log on a 2.6.9 (rhel 4.7) kernel :::
>

For RH 4.9 I did the attached patch. So this error is not fastfailed 
(upstream does not fastfail this type of error when using dm-multipath 
now). So now the scsi layer will retry its normal 5 times, then fail.


> SCSI error :<h b t l>  return code 0x8000002
> current sday: sense key Aborted Command
> Additional sense: Internal target failure
> end_request: I/O error, dev sday, sector XXXXX
> device-mapper: dm-multipath: Failing path 67:32.
>
> ::: unfortunate side effect of queue_if_no_path :::
>
> Activating "queue_if_no_path" is certainly an effecient work-around for this kind of short-lived retriable errors, but this feature compromises data-protection on clusters relying on persistent reservation to fence ios from passive nodes. Ironically, the reason is quite similar : SCSI return codes for reservation conflicts also end up invalidating each path of a multipath, and worse, the io causing the conflict gets queued ! and retried ! until the poor active drops its reservation, unleashing data-corrupting ios from passive node queues on the logical unit.
>
> ::: error log on a 2.6.29.x kernel for a reservation conflict :::
>
> sd h:b:t:l: reservation conflict
> sd h:b:t:l: [sdu] Unhandled error code
> sd h:b:t:l: [sdu] Result: hostbyte=DID_OK driver_byte=DRIVER_OK,SUGGEST_OK
> end_request: I/O error, dev sdu, sector XXXXX
> device-mapper: dm-multipath: Failing path 65:64.
>
> ::: persistent reservation + queue_if_no_path, possible solution ? :::
>
> Seems to me scsi_lib.c::scsi_io_completion() should be able to cancel a reservation conflicting io and signal blk_end_request() with no error reported.
>

I was just about to post new blkerr patches. For this we just wan 
multipath to fail this IO right away right? So have scsi return some 
fatal error then dm-multipath will see it and not retry that IO?

--------------060906060402030408040204
Content-Type: text/plain;
 name="dont-failfast-dev-errs.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dont-failfast-dev-errs.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2Vycm9yLmMgYi9kcml2ZXJzL3Njc2kv
c2NzaV9lcnJvci5jCmluZGV4IDczMDlmMTIuLmQ1YTMzOTAgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvc2NzaS9zY3NpX2Vycm9yLmMKKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfZXJyb3IuYwpA
QCAtMTM5MCw3ICsxMzkwLDcgQEAgaW50IHNjc2lfZGVjaWRlX2Rpc3Bvc2l0aW9uKHN0cnVj
dCBzY3NpX2NtbmQgKnNjbWQpCiAJY2FzZSBDSEVDS19DT05ESVRJT046CiAJCXJ0biA9IHNj
c2lfY2hlY2tfc2Vuc2Uoc2NtZCk7CiAJCWlmIChydG4gPT0gTkVFRFNfUkVUUlkpCi0JCQln
b3RvIG1heWJlX3JldHJ5OworCQkJZ290byBjaGVja19yZXRyeV9jb3VudDsKIAkJLyogaWYg
cnRuID09IEZBSUxFRCwgd2UgaGF2ZSBubyBzZW5zZSBpbmZvcm1hdGlvbjsKIAkJICogcmV0
dXJuaW5nIEZBSUxFRCB3aWxsIHdha2UgdGhlIGVycm9yIGhhbmRsZXIgdGhyZWFkCiAJCSAq
IHRvIGNvbGxlY3QgdGhlIHNlbnNlIGFuZCByZWRvIHRoZSBkZWNpZGUK
--------------060906060402030408040204
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060906060402030408040204--
