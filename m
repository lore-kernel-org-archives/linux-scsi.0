From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: Re: [PATCH v3] cmdfilter: clean up sysfs interface
Date: Fri, 8 Aug 2008 23:32:26 +0200
Message-ID: <6cf6b73e0808081432p2ca0d0dl8e86005fc5c94b72@mail.gmail.com>
References: <20080808174508Z.fujita.tomonori@lab.ntt.co.jp>
	 <6cf6b73e0808080505v5989bd3bm7beedea2b443bc55@mail.gmail.com>
	 <6cf6b73e0808081146n42a2b59bm1a55cc5f0cef41bb@mail.gmail.com>
	 <20080809060435V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_25814_9095279.1218231149781"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:57248 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760853AbYHHVca (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 17:32:30 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1227921rvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Aug 2008 14:32:29 -0700 (PDT)
In-Reply-To: <20080809060435V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, matthew@wil.cx, pjones@redhat.com, dougg@torque.net, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com

------=_Part_25814_9095279.1218231149781
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/8/8 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> On Fri, 8 Aug 2008 20:46:55 +0200
> "Adel Gadllah" <adel.gadllah@gmail.com> wrote:
>
>> v3 clean up parsing.
>>
>> -----------------------------------
>>
>> This patch changes the interface of the cmd filter to use a +/- notation like:
>> echo -- +0x02 +0x03 -0x08
>> If neither + or - is given it defaults to + (allow command).
>>
>> Note: The interface was added in 2.6.17-rc1 and is unused
>> and undocumented so far so it's safe to change it.
>>
>> Cc: matthew@wil.cx
>> Cc: fujita.tomonori@lab.ntt.co.jp,
>> Cc: jens.axboe@oracle.com
>> Cc: James.Bottomley@hansenpartnership.com
>> Cc: dan.j.williams@intel.com
>> Cc: pjones@redhat.com
>> Cc: viro@zeniv.linux.org.uk
>> Cc: dougg@torque.net
>> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
>>
>>  block/cmd-filter.c |   53 ++++++++++++++++++++++++++++++---------------------
>>  1 files changed, 31 insertions(+), 22 deletions(-)
>
> Hmm, the patch seems to be corrupted again.

OK, attached as file...

>
>> diff --git a/block/cmd-filter.c b/block/cmd-filter.c
>> index eec4404..f838d04 100644
>> --- a/block/cmd-filter.c
>> +++ b/block/cmd-filter.c
>
> I think that you can remove "linux/parser.h".
>
>
>> @@ -84,8 +84,8 @@ static ssize_t rcf_cmds_show(struct
>> blk_scsi_cmd_filter *filter, char *page,
>>
>>       for (i = 0; i < BLK_SCSI_MAX_CMDS; i++) {
>>               if (test_bit(i, okbits)) {
>> -                     sprintf(npage, "%02x", i);
>> -                     npage += 2;
>> +                     sprintf(npage, "0x%02x", i);
>> +                     npage += 4;
>>                       if (i < BLK_SCSI_MAX_CMDS - 1)
>>                               sprintf(npage++, " ");
>>               }
>> @@ -111,32 +111,41 @@ static ssize_t rcf_writecmds_show(struct
>> blk_scsi_cmd_filter *filter,
>>  static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
>>                             const char *page, size_t count, int rw)
>>  {
>> -     ssize_t ret = 0;
>>       unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
>> -     int cmd, status, len;
>> -     substring_t ss;
>> -
>> -     memset(&okbits, 0, sizeof(okbits));
>> -
>> -     for (len = strlen(page); len > 0; len -= 3) {
>> -             if (len < 2)
>> -                     break;
>> -             ss.from = (char *) page + ret;
>> -             ss.to = (char *) page + ret + 2;
>> -             ret += 3;
>> -             status = match_hex(&ss, &cmd);
>> +     int cmd, set;
>> +     char *p, *status;
>> +
>> +     if (rw == READ) {
>> +             memcpy(&okbits, filter->read_ok, sizeof(okbits));
>> +             target_okbits = filter->read_ok;
>> +     } else {
>> +             memcpy(&okbits, filter->write_ok, sizeof(okbits));
>> +             target_okbits = filter->write_ok;
>> +     }
>
> Do we need this? We can modify filter->write_ok or filter->read_ok
> directly?

Yes, because in case of an error (wrong input) only a part of the
request will be done (ex: enable 2 commands but not the third due to a
typo which might confuse the user).

>> +     while ((p = strsep((char **)&page, " ")) != NULL) {
>> +             set = 1;
>> +
>> +             if (p[0] == '-') {
>> +                     set = 0;
>> +                     p++;
>> +             }
>
> As I wrote, I prefer to let simple_strtol to handle '-' though the
> current code is also fine by me.

well this seems easier (see my last mail)

------=_Part_25814_9095279.1218231149781
Content-Type: application/octet-stream; name=cmd-filter-new-iface.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjnbc6av1
Content-Disposition: attachment; filename=cmd-filter-new-iface.patch

VGhpcyBwYXRjaCBjaGFuZ2VzIHRoZSBpbnRlcmZhY2Ugb2YgdGhlIGNtZCBmaWx0ZXIgdG8gdXNl
IGEgKy8tIG5vdGF0aW9uIGxpa2U6CmVjaG8gLS0gKzB4MDIgKzB4MDMgLTB4MDgKSWYgbmVpdGhl
ciArIG9yIC0gaXMgZ2l2ZW4gaXQgZGVmYXVsdHMgdG8gKyAoYWxsb3cgY29tbWFuZCkuCgpOb3Rl
OiBUaGUgaW50ZXJmYWNlIHdhcyBhZGRlZCBpbiAyLjYuMTctcmMxIGFuZCBpcyB1bnVzZWQKYW5k
IHVuZG9jdW1lbnRlZCBzbyBmYXIgc28gaXQncyBzYWZlIHRvIGNoYW5nZSBpdC4KCkNjOiBtYXR0
aGV3QHdpbC5jeApDYzogZnVqaXRhLnRvbW9ub3JpQGxhYi5udHQuY28uanAsCkNjOiBqZW5zLmF4
Ym9lQG9yYWNsZS5jb20KQ2M6IEphbWVzLkJvdHRvbWxleUBoYW5zZW5wYXJ0bmVyc2hpcC5jb20K
Q2M6IGRhbi5qLndpbGxpYW1zQGludGVsLmNvbQpDYzogcGpvbmVzQHJlZGhhdC5jb20KQ2M6IHZp
cm9AemVuaXYubGludXgub3JnLnVrCkNjOiBkb3VnZ0B0b3JxdWUubmV0ClNpZ25lZC1vZmYtYnk6
IEFkZWwgR2FkbGxhaCA8YWRlbC5nYWRsbGFoQGdtYWlsLmNvbT4KCmJsb2NrL2NtZC1maWx0ZXIu
YyB8ICAgNTQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCjEgZmlsZXMgY2hhbmdlZCwgMzEgaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvYmxvY2svY21kLWZpbHRlci5jIGIvYmxvY2svY21kLWZpbHRlci5jCmluZGV4
IGVlYzQ0MDQuLjcwYmU2MmQgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2NtZC1maWx0ZXIuYworKysgYi9i
bG9jay9jbWQtZmlsdGVyLmMKQEAgLTIwLDcgKzIwLDYgQEAKICNpbmNsdWRlIDxsaW51eC9saXN0
Lmg+CiAjaW5jbHVkZSA8bGludXgvZ2VuaGQuaD4KICNpbmNsdWRlIDxsaW51eC9zcGlubG9jay5o
PgotI2luY2x1ZGUgPGxpbnV4L3BhcnNlci5oPgogI2luY2x1ZGUgPGxpbnV4L2NhcGFiaWxpdHku
aD4KICNpbmNsdWRlIDxsaW51eC9iaXRvcHMuaD4KIApAQCAtODQsOCArODMsOCBAQCBzdGF0aWMg
c3NpemVfdCByY2ZfY21kc19zaG93KHN0cnVjdCBibGtfc2NzaV9jbWRfZmlsdGVyICpmaWx0ZXIs
IGNoYXIgKnBhZ2UsCiAKIAlmb3IgKGkgPSAwOyBpIDwgQkxLX1NDU0lfTUFYX0NNRFM7IGkrKykg
ewogCQlpZiAodGVzdF9iaXQoaSwgb2tiaXRzKSkgewotCQkJc3ByaW50ZihucGFnZSwgIiUwMngi
LCBpKTsKLQkJCW5wYWdlICs9IDI7CisJCQlzcHJpbnRmKG5wYWdlLCAiMHglMDJ4IiwgaSk7CisJ
CQlucGFnZSArPSA0OwogCQkJaWYgKGkgPCBCTEtfU0NTSV9NQVhfQ01EUyAtIDEpCiAJCQkJc3By
aW50ZihucGFnZSsrLCAiICIpOwogCQl9CkBAIC0xMTEsMzIgKzExMCw0MSBAQCBzdGF0aWMgc3Np
emVfdCByY2Zfd3JpdGVjbWRzX3Nob3coc3RydWN0IGJsa19zY3NpX2NtZF9maWx0ZXIgKmZpbHRl
ciwKIHN0YXRpYyBzc2l6ZV90IHJjZl9jbWRzX3N0b3JlKHN0cnVjdCBibGtfc2NzaV9jbWRfZmls
dGVyICpmaWx0ZXIsCiAJCQkgICAgICBjb25zdCBjaGFyICpwYWdlLCBzaXplX3QgY291bnQsIGlu
dCBydykKIHsKLQlzc2l6ZV90IHJldCA9IDA7CiAJdW5zaWduZWQgbG9uZyBva2JpdHNbQkxLX1ND
U0lfQ01EX1BFUl9MT05HXSwgKnRhcmdldF9va2JpdHM7Ci0JaW50IGNtZCwgc3RhdHVzLCBsZW47
Ci0Jc3Vic3RyaW5nX3Qgc3M7Ci0KLQltZW1zZXQoJm9rYml0cywgMCwgc2l6ZW9mKG9rYml0cykp
OwotCi0JZm9yIChsZW4gPSBzdHJsZW4ocGFnZSk7IGxlbiA+IDA7IGxlbiAtPSAzKSB7Ci0JCWlm
IChsZW4gPCAyKQotCQkJYnJlYWs7Ci0JCXNzLmZyb20gPSAoY2hhciAqKSBwYWdlICsgcmV0Owot
CQlzcy50byA9IChjaGFyICopIHBhZ2UgKyByZXQgKyAyOwotCQlyZXQgKz0gMzsKLQkJc3RhdHVz
ID0gbWF0Y2hfaGV4KCZzcywgJmNtZCk7CisJaW50IGNtZCwgc2V0OworCWNoYXIgKnAsICpzdGF0
dXM7CisKKwlpZiAocncgPT0gUkVBRCkgeworCQltZW1jcHkoJm9rYml0cywgZmlsdGVyLT5yZWFk
X29rLCBzaXplb2Yob2tiaXRzKSk7CisJCXRhcmdldF9va2JpdHMgPSBmaWx0ZXItPnJlYWRfb2s7
CisJfSBlbHNlIHsKKwkJbWVtY3B5KCZva2JpdHMsIGZpbHRlci0+d3JpdGVfb2ssIHNpemVvZihv
a2JpdHMpKTsKKwkJdGFyZ2V0X29rYml0cyA9IGZpbHRlci0+d3JpdGVfb2s7CisJfQorCisJd2hp
bGUgKChwID0gc3Ryc2VwKChjaGFyICoqKSZwYWdlLCAiICIpKSAhPSBOVUxMKSB7CisJCXNldCA9
IDE7CisKKwkJaWYgKHBbMF0gPT0gJy0nKSB7CisJCQlzZXQgPSAwOworCQkJcCsrOworCQl9CisK
KwkJaWYgKHBbMF0gPT0gJysnKQorCQkJcCsrOworCisJCWNtZCA9IHNpbXBsZV9zdHJ0b2wocCwg
JnN0YXR1cywgMTYpOworCiAJCS8qIGVpdGhlciBvZiB0aGVzZSBjYXNlcyBtZWFucyBpbnZhbGlk
IGlucHV0LCBzbyBkbyBub3RoaW5nLiAqLwotCQlpZiAoc3RhdHVzIHx8IGNtZCA+PSBCTEtfU0NT
SV9NQVhfQ01EUykKKwkJaWYgKChzdGF0dXMgPT0gcCkgfHwgY21kID49IEJMS19TQ1NJX01BWF9D
TURTKQogCQkJcmV0dXJuIC1FSU5WQUw7CiAKLQkJX19zZXRfYml0KGNtZCwgb2tiaXRzKTsKKwkJ
aWYgKHNldCkKKwkJCV9fc2V0X2JpdChjbWQsIG9rYml0cyk7CisJCWVsc2UKKwkJCV9fY2xlYXJf
Yml0KGNtZCwgb2tiaXRzKTsKIAl9CiAKLQlpZiAocncgPT0gUkVBRCkKLQkJdGFyZ2V0X29rYml0
cyA9IGZpbHRlci0+cmVhZF9vazsKLQllbHNlCi0JCXRhcmdldF9va2JpdHMgPSBmaWx0ZXItPndy
aXRlX29rOwotCiAJbWVtbW92ZSh0YXJnZXRfb2tiaXRzLCBva2JpdHMsIHNpemVvZihva2JpdHMp
KTsKIAlyZXR1cm4gY291bnQ7CiB9Cg==
------=_Part_25814_9095279.1218231149781--
