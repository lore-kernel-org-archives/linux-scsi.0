From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [BUG] "block: make generic_make_request handle arbitrarily sized
 bios" breaks boot on parisc-linux
Date: Wed, 24 Feb 2016 15:59:22 +0800
Message-ID: <CACVXFVOnff1sFfMH+zsoypuYwM4PokJkHeKhbxJYDDH6ZtVScg@mail.gmail.com>
References: <227C05EC-5A1C-4FAF-89D8-4A45AF600EC4@bell.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=94eb2c0327209ec937052c7f712c
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <227C05EC-5A1C-4FAF-89D8-4A45AF600EC4@bell.net>
Sender: linux-parisc-owner@vger.kernel.org
To: John David Anglin <dave.anglin@bell.net>
Cc: linux-block@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, Helge Deller <deller@gmx.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-parisc List <linux-parisc@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-scsi@vger.kernel.org

--94eb2c0327209ec937052c7f712c
Content-Type: text/plain; charset=UTF-8

On Wed, Feb 24, 2016 at 10:28 AM, John David Anglin
<dave.anglin@bell.net> wrote:
> The following block change breaks boot on parisc-linux:
>
> commit 54efd50bfd873e2dbf784e0b21a8027ba4299a3e
> Author: Kent Overstreet <kent.overstreet@gmail.com>
> Date:   Thu Apr 23 22:37:18 2015 -0700
>
>    block: make generic_make_request handle arbitrarily sized bios
>
>    The way the block layer is currently written, it goes to great lengths
>    to avoid having to split bios; upper layer code (such as bio_add_page())
>    checks what the underlying device can handle and tries to always create
>    bios that don't need to be split.
>
>    But this approach becomes unwieldy and eventually breaks down with
>    stacked devices and devices with dynamic limits, and it adds a lot of
>    complexity. If the block layer could split bios as needed, we could
>    eliminate a lot of complexity elsewhere - particularly in stacked
>    drivers. Code that creates bios can then create whatever size bios are
>    convenient, and more importantly stacked drivers don't have to deal with
>    both their own bio size limitations and the limitations of the
>    (potentially multiple) devices underneath them.  In the future this will
>    let us delete merge_bvec_fn and a bunch of other code.
>
>    We do this by adding calls to blk_queue_split() to the various
>    make_request functions that need it - a few can already handle arbitrary
>    size bios. Note that we add the call _after_ any call to
>    blk_queue_bounce(); this means that blk_queue_split() and
>    blk_recalc_rq_segments() don't need to be concerned with bouncing
>    affecting segment merging.
>
>    Some make_request_fn() callbacks were simple enough to audit and verify
>    they don't need blk_queue_split() calls. The skipped ones are:
>
>     * nfhd_make_request (arch/m68k/emu/nfblock.c)
>     * axon_ram_make_request (arch/powerpc/sysdev/axonram.c)
>     * simdisk_make_request (arch/xtensa/platforms/iss/simdisk.c)
>     * brd_make_request (ramdisk - drivers/block/brd.c)
>     * mtip_submit_request (drivers/block/mtip32xx/mtip32xx.c)
>     * loop_make_request
>     * null_queue_bio
>     * bcache's make_request fns
>
>    Some others are almost certainly safe to remove now, but will be left
>    for future patches.
>
>    Cc: Jens Axboe <axboe@kernel.dk>
>    Cc: Christoph Hellwig <hch@infradead.org>
>    Cc: Al Viro <viro@zeniv.linux.org.uk>
>    Cc: Ming Lei <ming.lei@canonical.com>
>    Cc: Neil Brown <neilb@suse.de>
>    Cc: Alasdair Kergon <agk@redhat.com>
>    Cc: Mike Snitzer <snitzer@redhat.com>
>    Cc: dm-devel@redhat.com
>    Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
>    Cc: drbd-user@lists.linbit.com
>    Cc: Jiri Kosina <jkosina@suse.cz>
>    Cc: Geoff Levand <geoff@infradead.org>
>    Cc: Jim Paris <jim@jtan.com>
>    Cc: Philip Kelleher <pjk1939@linux.vnet.ibm.com>
>    Cc: Minchan Kim <minchan@kernel.org>
>    Cc: Nitin Gupta <ngupta@vflare.org>
>    Cc: Oleg Drokin <oleg.drokin@intel.com>
>    Cc: Andreas Dilger <andreas.dilger@intel.com>
>    Acked-by: NeilBrown <neilb@suse.de> (for the 'md/md.c' bits)
>    Acked-by: Mike Snitzer <snitzer@redhat.com>
>    Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
>    Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
>    [dpark: skip more mq-based drivers, resolve merge conflicts, etc.]
>    Signed-off-by: Dongsu Park <dpark@posteo.net>
>    Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
>    Signed-off-by: Jens Axboe <axboe@fb.com>
>
> This thread on the linux-parisc has most of the discussion and analysis:
> http://www.spinics.net/lists/linux-parisc/msg06710.html
>
> Essentially, the SCSI layer underestimates the number of sg segments needed and we run off the end of the sg list and crash.
> This happens because the protect bit is ignored.  As a result 4.3 and later kernels fail to boot.  This includes the current Debian
> kernel for hppa.
>
> Hopefully, the block group can help resolve this issue.  We can help with testing if needed.
>

We fixed several similar bugs, but maybe there is another one, :-(

Could you apply the attached debug patch and post the log after the issue is
triggered?

Thanks,
Ming Lei

--94eb2c0327209ec937052c7f712c
Content-Type: text/x-patch; charset=US-ASCII; name="blk-merge_check-bvec.patch"
Content-Disposition: attachment; filename="blk-merge_check-bvec.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_il0jursq0

ZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1tZXJnZS5jIGIvYmxvY2svYmxrLW1lcmdlLmMKaW5kZXgg
MjYxMzUzMS4uMWE3M2ViNiAxMDA2NDQKLS0tIGEvYmxvY2svYmxrLW1lcmdlLmMKKysrIGIvYmxv
Y2svYmxrLW1lcmdlLmMKQEAgLTQxNiw2ICs0MTYsMjQgQEAgc2luZ2xlX3NlZ21lbnQ6CiAJcmV0
dXJuIG5zZWdzOwogfQogCitzdGF0aWMgdm9pZCBjaGVja19idmVjKHN0cnVjdCByZXF1ZXN0ICpy
ZXEpCit7CisJc3RydWN0IGJpb192ZWMgYnZlYzsKKwlzdHJ1Y3QgcmVxX2l0ZXJhdG9yIGl0ZXI7
CisJaW50IGkgPSAwOworCisJcHJpbnRrKCIlczogZHVtcCBidmVjIGZvciAlcChmOiVsbHgsIHQ6
JWQpXG4iLAorCQkJX19mdW5jX18sIHJlcSwgcmVxLT5jbWRfZmxhZ3MsCisJCQlyZXEtPmNtZF90
eXBlKTsKKwlycV9mb3JfZWFjaF9zZWdtZW50KGJ2ZWMsIHJlcSwgaXRlcikgeworCQlwcmludGso
Ilx0ICU0ZDogJXUgJXUgJWx1ICVwXG4iLAorCQkJICAgICBpLCBidmVjLmJ2X29mZnNldCwgYnZl
Yy5idl9sZW4sCisJCQkgICAgICh1bnNpZ25lZCBsb25nKXBhZ2VfdG9fcGZuKGJ2ZWMuYnZfcGFn
ZSksCisJCQkgICAgIGl0ZXIuYmlvKTsKKwkJaSsrOworCX0KK30KKwogLyoKICAqIG1hcCBhIHJl
cXVlc3QgdG8gc2NhdHRlcmxpc3QsIHJldHVybiBudW1iZXIgb2Ygc2cgZW50cmllcyBzZXR1cC4g
Q2FsbGVyCiAgKiBtdXN0IG1ha2Ugc3VyZSBzZyBjYW4gaG9sZCBycS0+bnJfcGh5c19zZWdtZW50
cyBlbnRyaWVzCkBAIC00MjUsNiArNDQzLDcgQEAgaW50IGJsa19ycV9tYXBfc2coc3RydWN0IHJl
cXVlc3RfcXVldWUgKnEsIHN0cnVjdCByZXF1ZXN0ICpycSwKIHsKIAlzdHJ1Y3Qgc2NhdHRlcmxp
c3QgKnNnID0gTlVMTDsKIAlpbnQgbnNlZ3MgPSAwOworCWJvb2wgZXh0cmFfbGVuID0gZmFsc2Us
IGRtYV9kcmFpbiA9IGZhbHNlOwogCiAJaWYgKHJxLT5iaW8pCiAJCW5zZWdzID0gX19ibGtfYmlv
c19tYXBfc2cocSwgcnEtPmJpbywgc2dsaXN0LCAmc2cpOwpAQCAtNDM2LDYgKzQ1NSw3IEBAIGlu
dCBibGtfcnFfbWFwX3NnKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgcmVxdWVzdCAq
cnEsCiAKIAkJc2ctPmxlbmd0aCArPSBwYWRfbGVuOwogCQlycS0+ZXh0cmFfbGVuICs9IHBhZF9s
ZW47CisJCWV4dHJhX2xlbiA9IHRydWU7CiAJfQogCiAJaWYgKHEtPmRtYV9kcmFpbl9zaXplICYm
IHEtPmRtYV9kcmFpbl9uZWVkZWQocnEpKSB7CkBAIC00NTAsNiArNDcwLDcgQEAgaW50IGJsa19y
cV9tYXBfc2coc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCByZXF1ZXN0ICpycSwKIAkJ
CSAgICAoUEFHRV9TSVpFIC0gMSkpOwogCQluc2VncysrOwogCQlycS0+ZXh0cmFfbGVuICs9IHEt
PmRtYV9kcmFpbl9zaXplOworCQlkbWFfZHJhaW4gPSB0cnVlOwogCX0KIAogCWlmIChzZykKQEAg
LTQ2MCw2ICs0ODEsMTIgQEAgaW50IGJsa19ycV9tYXBfc2coc3RydWN0IHJlcXVlc3RfcXVldWUg
KnEsIHN0cnVjdCByZXF1ZXN0ICpycSwKIAkgKiBzZWdtZW50IGlzIGJpZ2dlciB0aGFuIG51bWJl
ciBvZiByZXEncyBwaHlzaWNhbCBzZWdtZW50cwogCSAqLwogCVdBUk5fT04obnNlZ3MgPiBycS0+
bnJfcGh5c19zZWdtZW50cyk7CisJaWYgKG5zZWdzID4gcnEtPm5yX3BoeXNfc2VnbWVudHMpIHsK
KwkJcHJpbnRrKCIlczogbWVyZ2UgYnVnOiAlZCAlZCwgZXh0cmFfbGVuICVkLCBkbWFfZHJhaW4g
JWRcbiIsCisJCQlfX2Z1bmNfXywgbnNlZ3MsIHJxLT5ucl9waHlzX3NlZ21lbnRzLAorCQkJZXh0
cmFfbGVuLCBkbWFfZHJhaW4pOworCQljaGVja19idmVjKHJxKTsKKwl9CiAKIAlyZXR1cm4gbnNl
Z3M7CiB9Cg==
--94eb2c0327209ec937052c7f712c--
