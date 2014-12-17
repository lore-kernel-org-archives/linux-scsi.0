From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH 0/1] int to bool conversion
Date: Wed, 17 Dec 2014 15:53:32 +0100
Message-ID: <20141217145332.GA2762@sloth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch converts local variable declared as integer and used as
boolean into actual booleans. It only patches variables that are not
returned to limit the scope of the changes.

This patch was generated with Coccinelle using the semantic patch below.


Quentin Lambert (1):
  [SCSI] mpt2sas: Convert non-returned local variable to boolean when
    relevant

 drivers/scsi/mpt2sas/mpt2sas_base.c      | 24 ++++++++++++------------
 drivers/scsi/mpt2sas/mpt2sas_config.c    |  5 +++--
 drivers/scsi/mpt2sas/mpt2sas_ctl.c       | 22 +++++++++++-----------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 17 ++++++++---------
 drivers/scsi/mpt2sas/mpt2sas_transport.c | 27 ++++++++++++++-------------
 5 files changed, 48 insertions(+), 47 deletions(-)

-- 


/* match all explicit boolean functions */
@boolean_function@
identifier fbool;
typedef bool;
@@

bool fbool(...) {
...
}

/* match variables eligible for boolean conversion */
@eligible_var exists@
identifier f, boolean_function.fbool;
typedef u1, u2, u4, u8, u16, u32;
local idexpression {int, u8, u1, u2, u4, u16, u32, char} x;
identifier xname;
expression e1, e2;
position p;
@@


f@p(...) {
...when any
(
  x@xname = 1;
|
  x@xname = 0;
|
  x@xname = (e1) ? 0 : 1;
|
  x@xname = (e2) ? 1 : 0;
|
  x@xname = fbool(...);
|
  x@xname = fbool(...);
|
  x@xname = e1 && ...
|
  x@xname = e1 || ...
|
  x@xname = e1 == e2
|
  x@xname = e1 != e2
|
  x@xname = e1 < e2
|
  x@xname = e1 <= e2
|
  x@xname = e1 > e2
|
  x@xname = e1 >= e2
)
...when any
}

/* match all acceptable complex assignement */
@valid_assign exists@
identifier eligible_var.f, boolean_function.fbool;
local idexpression {int, u8, u1, u2, u4, u16, u32, char} eligible_var.x;
expression e1, e2;
position p;
@@

f(...) {
...when any
(
  x@p = (e1) ? 0 : 1;
|
  x@p = (e1) ? 1 : 0;
|
  x@p = fbool(...);
|
  x@p = e1 && ...
|
  x@p = e1 || ...
|
  x@p = e1 == e2
|
  x@p = e1 != e2
|
  x@p = e1 < e2
|
  x@p = e1 <= e2
|
  x@p = e1 > e2
|
  x@p = e1 >= e2
)
...when any
}

/* match any expression where x is used as an int */
@badvar1 exists@
identifier eligible_var.f;
local idexpression {int, u8, u1, u2, u4, u16, u32, char} eligible_var.x;
expression e1 != {0, 1}, e2;
position p != {valid_assign.p};
@@

f(...) {
...when any
(
  x@p = e1;
|
  x += e2
|
  e2 += x
|
  x *= e2
|
  e2 *= x
|
  x -= e2
|
  e2 -= x
|
  x /= e2
|
  e2 /= x
|
  e2 %= x
|
  x %= e2
|
  x &= e2
|
  e2 &= x
|
  x |= e2
|
  e2 |= x
|
  x ^= e2
|
  e2 ^= x
|
  x <<= e2
|
  e2 <<= x  
|
  x >>= e2
|
  e2 >>= x  
|
  x++
|
  ++x
|
  x--
|
  --x
|
  x + e2
|
  x - e2
|
  e2 - x
|
  x & e2
|
  x | e2
|
  x * e2
|
  x / e2
|
  e2 / x
|
  x % e2
|
  e2 % x
|
  ~x
|
  e2 ^ x
|
  x ^ e2
|
  x << e2
|
  e2 << x
|
  x >> e2
|
  e2 >> x
|
  return x;
)
...when any
}



@depends on !badvar1@
identifier eligible_var.f;
local idexpression {int, u8, u1, u2, u4, u16, u32, char} eligible_var.x;
identifier eligible_var.xname;
type t;
expression e;
@@


f(...) {
...
(
++ bool xname = false;
- t xname = 0;
|
++ bool xname = true;
- t xname = 1;
|
++ bool xname;
- t xname;
)
<...
(
  x =
- 1
+ true
|
  x =
- 0
+ false
|
- x = (e) ? 1 : 0
+ x = (e) ? true : false
|
- x = (e) ? 0 : 1
+ x = (e) ? false : true
)
...>

}
